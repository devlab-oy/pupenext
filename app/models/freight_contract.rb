class FreightContract < BaseModel
  belongs_to :customer, foreign_key: :asiakas, primary_key: :tunnus

  scope :ordered, -> { order :ytunnus, :toimitustapa }
  scope :limited, -> { limit 350 }

  validates :rahtisopimus, presence: true
  validates :customer, presence: true

  self.table_name = :rahtisopimukset
  self.primary_key = :tunnus
end
