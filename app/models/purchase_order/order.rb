class PurchaseOrder::Order < Head
  has_many :rows, foreign_key: :otunnus, class_name: 'PurchaseOrder::Row'

  validates :tila, inclusion: { in: ['O'] }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "O"
  end
end
