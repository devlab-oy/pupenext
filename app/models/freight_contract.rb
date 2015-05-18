class FreightContract < BaseModel
  belongs_to :customer, foreign_key: :asiakas, primary_key: :tunnus

  validates :rahtisopimus, presence: true
  validates :customer, presence: true

  self.table_name = :rahtisopimukset
  self.primary_key = :tunnus
end
