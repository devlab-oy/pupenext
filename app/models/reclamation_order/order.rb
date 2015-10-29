class ReclamationOrder::Order < Head
  has_many :rows, foreign_key: :otunnus, class_name: 'ReclamationOrder::Row'

  validates :tila, inclusion: { in: ['C'] }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "C"
  end
end
