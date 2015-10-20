class ManufactureOrder::Row < Row
  belongs_to :order, foreign_key: :otunnus, class_name: 'ManufactureOrder::Order'

  validates :tyyppi, inclusion: { in: ['V'] }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "V"
  end
end
