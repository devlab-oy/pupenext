class ManufactureOrder::Order < Head
  has_many :rows, foreign_key: :otunnus, class_name: 'ManufactureOrder::Row'

  validates :tila, inclusion: { in: ['V'] }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "V"
  end
end
