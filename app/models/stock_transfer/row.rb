class StockTransfer::Row < Row
  belongs_to :order, foreign_key: :otunnus, class_name: 'StockTransfer::Order'

  validates :tyyppi, inclusion: { in: ['G'] }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "G"
  end
end
