class Supplier < BaseModel
  include Searchable
  include UserDefinedValidations

  has_many :product_suppliers, foreign_key: :liitostunnus, class_name: 'Product::Supplier'
  has_many :products, through: :product_suppliers
  has_many :supplier_product_informations

  self.table_name = :toimi
  self.primary_key = :tunnus
end
