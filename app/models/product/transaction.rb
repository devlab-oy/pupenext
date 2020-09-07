class Product::Transaction < BaseModel
  belongs_to :product, foreign_key: :tuoteno, primary_key: :tuoteno

  self.table_name = :tapahtuma
  self.primary_key = :tunnus
  self.record_timestamps = false
end
