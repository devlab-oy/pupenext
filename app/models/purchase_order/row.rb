class PurchaseOrder::Row < Row
  belongs_to :order, foreign_key: :otunnus, class_name: 'PurchaseOrder::Order'

  validates :tyyppi, inclusion: { in: ['O'] }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "O"
  end
end
