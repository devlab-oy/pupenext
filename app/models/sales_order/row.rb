class SalesOrder::Row < Row
  validates :tyyppi, inclusion: { in: ['L'] }

  scope :open, -> { where("(tilausrivi.varattu + tilausrivi.jt) > 0 AND tilausrivi.laskutettuaika = '0000-00-00'") }

  def reserved
    varattu + jt
  end

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "L"
  end
end
