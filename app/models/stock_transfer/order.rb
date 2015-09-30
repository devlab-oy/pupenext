class StockTransfer::Order < Head
  has_many :rows, foreign_key: :otunnus, class_name: 'StockTransfer::Row'

  validates :tila, inclusion: { in: ['G'] }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "G"
  end
end
