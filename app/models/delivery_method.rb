class DeliveryMethod < BaseModel
  has_many :freight_contracts, foreign_key: :toimitustapa, primary_key: :selite

  self.table_name = :toimitustapa
  self.primary_key = :tunnus
end
