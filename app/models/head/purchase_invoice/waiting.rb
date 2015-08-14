class Head::PurchaseInvoice::Waiting < Head::PurchaseInvoice
  validates :tila, inclusion: { in: ['Q'] }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    'Q'
  end

  def self.human_readable_type
    "Ostolasku odottaa suoritusta"
  end
end
