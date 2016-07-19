class Product::Supplier < BaseModel
  belongs_to :product,  foreign_key: :tuoteno,      primary_key: :tuoteno
  belongs_to :supplier, foreign_key: :liitostunnus, primary_key: :tunnus, class_name: '::Supplier'

  self.table_name = :tuotteen_toimittajat
  self.primary_key = :tunnus
end
