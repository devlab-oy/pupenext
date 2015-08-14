class Head::PurchaseInvoice::Paid < Head::PurchaseInvoice
  has_many :rows, foreign_key: :ltunnus, primary_key: :tunnus, class_name: 'Head::VoucherRow'
  validates :tila, inclusion: { in: ['Y'] }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    'Y'
  end

  def self.find_by_account(account_no)
    joins(:rows).where(tiliointi: { tilino: account_no })
  end
end
