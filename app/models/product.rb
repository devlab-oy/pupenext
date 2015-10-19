class Product < BaseModel
  include Searchable

  belongs_to :category,     foreign_key: :osasto,      primary_key: :selite,  class_name: 'Product::Category'
  belongs_to :subcategory,  foreign_key: :try,         primary_key: :selite,  class_name: 'Product::Subcategory'
  belongs_to :brand,        foreign_key: :tuotemerkki, primary_key: :selite,  class_name: 'Product::Brand'
  belongs_to :status,       foreign_key: :status,      primary_key: :selite,  class_name: 'Product::Status'

  has_many :pending_updates, as: :pending_updatable, dependent: :destroy
  has_many :suppliers, through: :product_suppliers
  has_many :attachments, foreign_key: :liitostunnus, class_name: 'Attachment::ProductAttachment'
  has_many :customer_prices, foreign_key: :tuoteno

  delegate :images, to: :attachments
  delegate :thumbnails, to: :attachments

  with_options foreign_key: :tuoteno, primary_key: :tuoteno do |o|
    o.has_many :keywords, class_name: 'Product::Keyword'
    o.has_many :manufacture_rows, class_name: 'ManufactureOrder::Row'
    o.has_many :product_suppliers, class_name: 'Product::Supplier'
    o.has_many :purchase_order_rows, class_name: 'PurchaseOrder::Row'
    o.has_many :sales_order_rows, class_name: 'SalesOrder::Row'
    o.has_many :shelf_locations
    o.has_many :stock_transfer_rows, class_name: 'StockTransfer::Row'
  end

  accepts_nested_attributes_for :pending_updates, allow_destroy: true

  validates :nimitys, presence: true

  self.table_name = :tuote
  self.primary_key = :tunnus

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

  def stock
    shelf_locations.sum(:saldo)
  end

  def stock_reserved
    stock_reserved  = sales_order_rows.reserved
    stock_reserved += manufacture_rows.reserved
    stock_reserved += stock_transfer_rows.reserved
    stock_reserved
  end

  def stock_available
    stock - stock_reserved
  end

  def customer_price(customer_id)
    LegacyMethods.customer_price(customer_id, id)
  end

  def customer_subcategory_price(customer_subcategory_id)
    LegacyMethods.customer_subcategory_price(customer_subcategory_id, id)
  end

  def cover_image
    attachments.order(:jarjestys, :tunnus).first
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
end
