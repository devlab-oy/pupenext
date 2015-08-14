class Head::PurchaseInvoice::Transfer < Head::PurchaseInvoice
  validates :tila, inclusion: { in: ['P'] }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    'P'
  end

  def self.human_readable_type
    "Ostolasku lähdössä pankkiin"
  end
end
