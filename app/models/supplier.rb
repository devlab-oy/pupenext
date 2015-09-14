class Supplier < BaseModel
  has_many :product_suppliers, foreign_key: :liitostunnus, class_name: 'Product::Supplier'
  has_many :products, through: :product_suppliers

  self.table_name = :toimi
  self.primary_key = :tunnus
end
