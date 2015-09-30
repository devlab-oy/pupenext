class ShelfLocation < BaseModel
  belongs_to :product, foreign_key: :tuoteno, primary_key: :tuoteno
  belongs_to :warehouse, foreign_key: :varasto

  self.table_name = :tuotepaikat
  self.primary_key = :tunnus
end
