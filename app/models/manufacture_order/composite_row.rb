class ManufactureOrder::CompositeRow < Row
  belongs_to :order, foreign_key: :otunnus, class_name: 'ManufactureOrder::Order'

  # Valmiste
  validates :tyyppi, inclusion: { in: ['W'] }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "W"
  end
end
