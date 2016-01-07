class SalesOrder::DetailRow < Row
  belongs_to :order, foreign_key: :otunnus, class_name: 'SalesOrder::Detail'

  validates :tyyppi, inclusion: { in: ['9'] }
  validates :tuoteno, presence: true

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "9"
  end
end
