class SalesOrder::Row < Row
  belongs_to :order, foreign_key: :otunnus, class_name: 'SalesOrder::Base'
  has_one :product, foreign_key: :tuoteno, primary_key: :tuoteno

  validates :tyyppi, inclusion: { in: ['L'] }

  scope :open, -> { where("(tilausrivi.varattu + tilausrivi.jt) > 0 AND tilausrivi.laskutettuaika = '0000-00-00'") }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "L"
  end
end
