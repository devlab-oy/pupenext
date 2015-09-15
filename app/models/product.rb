class Product < BaseModel
  include Searchable

  has_many :product_suppliers, foreign_key: :tuoteno, primary_key: :tuoteno, class_name: 'Product::Supplier'
  has_many :suppliers, through: :product_suppliers
  has_many :pending_updates, as: :pending_updatable, dependent: :destroy

  belongs_to :category,     foreign_key: :osasto,      primary_key: :selite,  class_name: 'Product::Category'
  belongs_to :subcategory,  foreign_key: :try,         primary_key: :selite,  class_name: 'Product::Subcategory'
  belongs_to :brand,        foreign_key: :tuotemerkki, primary_key: :selite,  class_name: 'Product::Brand'
  belongs_to :status,       foreign_key: :status,      primary_key: :selite,  class_name: 'Product::Status'

  accepts_nested_attributes_for :pending_updates, allow_destroy: true

  self.table_name = :tuote
  self.primary_key = :tunnus

  before_create :set_date_fields

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
