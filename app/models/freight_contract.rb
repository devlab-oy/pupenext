class FreightContract < BaseModel
  include Searchable

  belongs_to :customer, foreign_key: :asiakas
  belongs_to :delivery_method, foreign_key: :toimitustapa, primary_key: :selite

  scope :ordered, -> { order :ytunnus, :toimitustapa }

  validates :customer, presence: true
  validates :rahtisopimus, presence: true
  validates :delivery_method, presence: true

  self.table_name = :rahtisopimukset
  self.primary_key = :tunnus
end
