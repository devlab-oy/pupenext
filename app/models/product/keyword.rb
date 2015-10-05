class Product::Keyword < BaseModel
  belongs_to :product, foreign_key: :tuoteno, primary_key: :tuoteno

  self.table_name = :tuotteen_avainsanat
  self.primary_key = :tunnus
end
