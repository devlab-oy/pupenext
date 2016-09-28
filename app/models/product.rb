class Product < BaseModel
  include AttributeSanitator
  include Searchable
  include UserDefinedValidations

  float_columns :myyntihinta, :myymalahinta

  belongs_to :category,     foreign_key: :osasto,      primary_key: :selite,  class_name: 'Product::Category'
  belongs_to :subcategory,  foreign_key: :try,         primary_key: :selite,  class_name: 'Product::Subcategory'
  belongs_to :brand,        foreign_key: :tuotemerkki, primary_key: :selite,  class_name: 'Product::Brand'

  has_many :pending_updates, as: :pending_updatable, dependent: :destroy
  has_many :suppliers, through: :product_suppliers
  has_many :attachments, foreign_key: :liitostunnus, class_name: 'Attachment::ProductAttachment'
  has_many :customer_prices, foreign_key: :tuoteno, primary_key: :tuoteno
  has_many :customers, through: :customer_prices
  has_many :product_links, foreign_key: :liitos, primary_key: :tuoteno, class_name: 'Category::ProductLink'
  has_many :product_categories, through: :product_links, source: :category, class_name: 'Category::Product'

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

  has_many :warehouses, through: :shelf_locations

  accepts_nested_attributes_for :pending_updates, allow_destroy: true

  validates :nimitys, presence: true
  validates :tuoteno, presence: true, uniqueness: { scope: [:yhtio] }
  validates :status, presence: true
  validates_numericality_of :myyntihinta, :myymalahinta

  self.table_name = :tuote
  self.primary_key = :tunnus

  before_save :defaults

  enum status: {
    status_active: 'A',
    preorder: 'E',
    deleted: 'P',
    order_only: 'T',
    to_be_deleted: 'X',
  }

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
  scope :not_deleted, -> { where.not(status: :P) }
  scope :regular, -> { where(tuotetyyppi: ['', :R, :M, :K]) }
  scope :viranomaistuotteet, -> { not_deleted.where(tuotetyyppi: [:A, :B]) }

  def as_json(options = {})
    options = { only: :tunnus }.merge(options)
    super options
  end

  def stock
    Stock.new(self).stock
  end

  def stock_reserved(stock_date: Date.current)
    Stock.new(self, stock_date: stock_date).stock_reserved
  end

  def stock_available(stock_date: Date.current)
    Stock.new(self, stock_date: stock_date).stock_available
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
      customer_subcategory_price_with_info(target.selite)[:contract_price]
    else
      false
    end
  end

  private

    def defaults
      self.vienti ||= ''
      self.status ||= :status_active
    end
end

require_dependency 'product/category'
