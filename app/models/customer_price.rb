class CustomerPrice < BaseModel
  belongs_to :product, foreign_key: :tuoteno, primary_key: :tuoteno

  self.table_name        = :asiakashinta
  self.primary_key       = :tunnus
  self.record_timestamps = false
end
