class Freight < BaseModel
  belongs_to :delivery_method,  foreign_key: :toimitustapa, primary_key: :selite

  self.table_name = :rahtimaksut
  self.primary_key = :tunnus
end
