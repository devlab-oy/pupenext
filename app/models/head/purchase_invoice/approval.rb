class Head::PurchaseInvoice::Approval < Head::PurchaseInvoice
  validates :tila, inclusion: { in: ['H'] }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    'H'
  end

  def self.human_readable_type
    "Ostolasku hyväksyttävänä"
  end
end
