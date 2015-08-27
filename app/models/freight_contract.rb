class FreightContract < BaseModel
  belongs_to :delivery_method,  foreign_key: :toimitustapa, primary_key: :selite

  self.table_name = :rahtisopimukset
  self.primary_key = :tunnus
end
