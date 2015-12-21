class ManufactureOrder::RecursiveCompositeRow < Row
  belongs_to :order, foreign_key: :otunnus, class_name: 'ManufactureOrder::Order'

  # Valmiste (Rekursiivinen)
  validates :tyyppi, inclusion: { in: ['M'] }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "M"
  end
end
