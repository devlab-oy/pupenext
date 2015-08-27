class CustomerKeyword < BaseModel
  belongs_to :delivery_method,  foreign_key: :toimitustapa, primary_key: :avainsana

  self.table_name = :asiakkaan_avainsanat
  self.primary_key = :tunnus
end
