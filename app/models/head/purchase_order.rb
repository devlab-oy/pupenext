class Head::PurchaseOrder < Head
  validates :tila, inclusion: { in: ['O'] }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "O"
  end
end
