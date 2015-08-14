class Head::PurchaseInvoice::Approved < Head::PurchaseInvoice
  validates :tila, inclusion: { in: ['M'] }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    'M'
  end
end
