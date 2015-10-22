class SalesOrder::Order < Head
  has_many :rows, foreign_key: :otunnus, class_name: 'SalesOrder::Row'

  validates :tila, inclusion: { in: ['L'] }

  scope :not_delivered, -> { where(alatila: %w(A C)) }
  scope :invoiced, -> { where(alatila: 'X') }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "L"
  end
end
