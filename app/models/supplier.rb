class Supplier < BaseModel
  include Searchable
  include UserDefinedValidations

  has_many :product_suppliers, foreign_key: :liitostunnus, class_name: 'Product::Supplier'
  has_many :products, through: :product_suppliers
  has_many :supplier_product_informations

  ACTIVE_TYPES = %w(
    normal
    for_every_product
    travelling_expense_user
  ).freeze

  scope :active, -> { where(tyyppi: tyyppis.values_at(*ACTIVE_TYPES)) }

  enum tyyppi: {
    normal: '',
    for_every_product: 'L',
    travelling_expense_user: 'K',
    inactive: 'P',
  }

  self.table_name = :toimi
  self.primary_key = :tunnus
end
