class WorkOrder::Order < Head
  has_many :rows, foreign_key: :otunnus, class_name: 'WorkOrder::Row'

  validates :tila, inclusion: { in: ['A'] }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "A"
  end
end
