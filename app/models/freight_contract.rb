class FreightContract < BaseModel
  include Searchable

  belongs_to :customer, foreign_key: :asiakas, primary_key: :tunnus
  belongs_to :delivery_method, foreign_key: :toimitustapa, primary_key: :selite

  scope :ordered, -> { order :ytunnus, :toimitustapa }

  validates :rahtisopimus, presence: true
  validates :delivery_method, presence: true

  class << self
    def with_customer
      joins("LEFT JOIN asiakas ON asiakas.yhtio = rahtisopimukset.yhtio
             AND asiakas.tunnus = rahtisopimukset.asiakas")
        .select("rahtisopimukset.*",
                "asiakas.nimi AS customer_name",
                "asiakas.tunnus AS customer_id")
    end
  end

  self.table_name = :rahtisopimukset
  self.primary_key = :tunnus
end
