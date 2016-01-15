class CustomerKeyword < BaseModel
  belongs_to :delivery_method,  foreign_key: :avainsana, primary_key: :selite
  belongs_to :customer, foreign_key: :liitostunnus

  self.table_name = :asiakkaan_avainsanat
  self.primary_key = :tunnus
end
