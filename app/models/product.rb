class Product < BaseModel
  include Searchable

  belongs_to :category,     foreign_key: :osasto,      primary_key: :selite,  class_name: 'Product::Category'
  belongs_to :subcategory,  foreign_key: :try,         primary_key: :selite,  class_name: 'Product::Subcategory'
  belongs_to :brand,        foreign_key: :tuotemerkki, primary_key: :selite,  class_name: 'Product::Brand'
  belongs_to :status,       foreign_key: :status,      primary_key: :selite,  class_name: 'Product::Status'

  has_many :pending_updates, as: :pending_updatable, dependent: :destroy
  has_many :suppliers, through: :product_suppliers
  has_many :attachments, foreign_key: :liitostunnus, class_name: 'Attachment::ProductAttachment'
  has_many :customer_prices, foreign_key: :tuoteno, primary_key: :tuoteno
  has_many :customers, through: :customer_prices
  has_many :dynamic_tree_nodes, class_name: 'DynamicTreeNode::ProductNode', foreign_key: :liitos, primary_key: :tuoteno
  has_many :dynamic_trees, through: :dynamic_tree_nodes

  with_options foreign_key: :liitostunnus, class_name: 'Attachment::ProductAttachment' do |o|
    o.has_one :cover_image, -> { where(kayttotarkoitus: :tk).order(:jarjestys, :tunnus) }
    o.has_one :cover_thumbnail, -> { where(kayttotarkoitus: :th).order(:jarjestys, :tunnus) }
  end

  delegate :images, to: :attachments
  delegate :thumbnails, to: :attachments

  with_options foreign_key: :tuoteno, primary_key: :tuoteno do |o|
    o.has_many :keywords, class_name: 'Product::Keyword'
    o.has_many :manufacture_composite_rows, class_name: 'ManufactureOrder::CompositeRow'
    o.has_many :manufacture_recursive_composite_rows, class_name: 'ManufactureOrder::RecursiveCompositeRow'
    o.has_many :manufacture_rows, class_name: 'ManufactureOrder::Row'
    o.has_many :product_suppliers, class_name: 'Product::Supplier'
    o.has_many :purchase_order_rows, class_name: 'PurchaseOrder::Row'
    o.has_many :sales_order_rows, class_name: 'SalesOrder::Row'
    o.has_many :shelf_locations
    o.has_many :stock_transfer_rows, class_name: 'StockTransfer::Row'
  end

  accepts_nested_attributes_for :pending_updates, allow_destroy: true

  validates :nimitys, presence: true
  validates_numericality_of :myyntihinta, :myymalahinta

  self.table_name = :tuote
  self.primary_key = :tunnus

  before_save :defaults
  before_create :set_date_fields

  enum tuotetyyppi: {
    expence: 'B',
    material: 'R',
    normal: '',
    other: 'M',
    per_diem: 'A',
    service: 'K',
  }

  enum ei_saldoa: {
    inventory_management: '',
    no_inventory_management: 'o'
  }

  scope :active, -> { not_deleted.regular }
  scope :deleted, -> { where(status: :P) }
  scope :not_deleted, -> { where.not(status: :P) }
  scope :regular, -> { where(tuotetyyppi: ['', :R, :M, :K]) }
  scope :viranomaistuotteet, -> { not_deleted.where(tuotetyyppi: [:A, :B]) }
  scope :active, -> { not_deleted.where(tuotetyyppi: ['', :R, :M, :K]) }

  def as_json(options = {})
    options = { only: :tunnus }.merge(options)
    super options
  end

  def stock
    return 0 if no_inventory_management?

    shelf_locations.sum(:saldo)
  end

  def stock_reserved(stock_date: Date.today)
    return 0 if no_inventory_management?

    if company.parameter.stock_management_by_pick_date?
      pick_date_stock_reserved stock_date: stock_date
    elsif company.parameter.stock_management_by_pick_date_and_with_future_reservations?
      pick_date_and_future_reserved stock_date: stock_date
    else
      default_stock_reserved
    end
  end

  def stock_available(stock_date: Date.today)
    stock - stock_reserved(stock_date: stock_date)
  end

  def customer_price(customer_id)
    LegacyMethods.customer_price(customer_id, id)
  end

  def customer_price_with_info(customer_id)
    LegacyMethods.customer_price_with_info(customer_id, id)
  end

  def customer_subcategory_price(customer_subcategory_id)
    LegacyMethods.customer_subcategory_price(customer_subcategory_id, id)
  end

  def customer_subcategory_price_with_info(customer_subcategory_id)
    LegacyMethods.customer_subcategory_price_with_info(customer_subcategory_id, id)
  end

  # Avoimet myyntirivit
  def open_sales_order_rows_between(range)
    sales_order_rows.open.where(toimaika: range)
  end

  # Avoimet ostorivit
  def open_purchase_order_rows_between(range)
    purchase_order_rows.open.where(toimaika: range)
  end

  def contract_price?(target)
    if target.is_a? Customer
      customer_price_with_info(target.id)[:contract_price]
    elsif target.is_a? ::Keyword::CustomerSubcategory
      customer_subcategory_price_with_info(target.id)[:contract_price]
    else
      false
    end
  end

  private

    def set_date_fields
      # Date fields can be set to zero
      self.vihapvm           ||= 0
      self.epakurantti25pvm  ||= 0
      self.epakurantti50pvm  ||= 0
      self.epakurantti75pvm  ||= 0
      self.epakurantti100pvm ||= 0
    end

    def defaults
      self.vienti ||= ''
    end

    def default_stock_reserved
      # sales, manufacture, and stock trasfer rows reserve stock
      stock_reserved  = sales_order_rows.reserved
      stock_reserved += manufacture_rows.reserved
      stock_reserved += stock_transfer_rows.reserved
      stock_reserved
    end

    def pick_date_stock_reserved(stock_date: Date.today)
      # sales, manufacture, and stock trasfer rows
      # *reserve stock* if they are due to be picked in the past
      stock_reserved  = sales_order_rows.where('tilausrivi.kerayspvm <= ?', stock_date).reserved
      stock_reserved += manufacture_rows.where('tilausrivi.kerayspvm <= ?', stock_date).reserved
      stock_reserved += stock_transfer_rows.where('tilausrivi.kerayspvm <= ?', stock_date).reserved

      # sales, manufacture, and stock trasfer rows
      # *reserve stock* if they are due to be picked in the future, but are already picked
      stock_reserved += sales_order_rows.picked.where('tilausrivi.kerayspvm > ?', stock_date).reserved
      stock_reserved += manufacture_rows.picked.where('tilausrivi.kerayspvm > ?', stock_date).reserved
      stock_reserved += stock_transfer_rows.picked.where('tilausrivi.kerayspvm > ?', stock_date).reserved

      # manufacture composite rows and manufacture recursive composite rows
      # *decrease stock reservation* if they are due to be picked in the past
      stock_reserved -= manufacture_composite_rows.where('tilausrivi.kerayspvm <= ?', stock_date).reserved
      stock_reserved -= manufacture_recursive_composite_rows.where('tilausrivi.kerayspvm <= ?', stock_date).reserved

      # purchase orders due to arrive in the past *decrease stock reservation*
      stock_reserved -= purchase_order_rows.where('tilausrivi.toimaika <= ?', stock_date).reserved

      stock_reserved
    end

    def pick_date_and_future_reserved(stock_date: Date.today)
      relations = %w{
        manufacture_composite_rows
        manufacture_recursive_composite_rows
        manufacture_rows
        purchase_order_rows
        sales_order_rows
        stock_transfer_rows
      }

      # fetch all distinct pick dates for all product rows
      dates = [ stock_date ]
      dates << relations.map do |relation|
        send(relation)
          .where('tilausrivi.kerayspvm > ?', stock_date)
          .where('tilausrivi.varattu + tilausrivi.jt != 0')
          .select(:kerayspvm)
          .distinct
          .map(&:kerayspvm)
      end

      # fetch stock reserved for each date
      stock_by_date = dates.flatten.compact.map do |date|
        pick_date_stock_reserved stock_date: date
      end

      # return maximum stock reservation in the future (worst case)
      stock_by_date.max || 0
    end
end

require_dependency 'product/category'
