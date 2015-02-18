class Head::PurchaseInvoice::Paid < Head::PurchaseInvoice
  has_many :rows, foreign_key: :ltunnus, primary_key: :tunnus, class_name: 'Head::VoucherRow'
  validates :tila, inclusion: { in: ['Y'] }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    'Y'
  end

  def self.human_readable_type
    "Ostolasku maksettu"
  end

  # Rails figures out paths from the model name. User model has users_path etc.
  # With STI we want to use same name for each child. Thats why we override model_name
  def self.model_name
    Head.model_name
  end
end
