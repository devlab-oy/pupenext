class SalesOrder::Order < Head
  has_many :rows, foreign_key: :otunnus, class_name: 'SalesOrder::Row'
  has_one :extra, foreign_key: :otunnus, primary_key: :tunnus, class_name: 'Head::SalesInvoiceExtra'
  belongs_to :invoice, foreign_key: :laskunro, primary_key: :laskunro, class_name: 'Head::SalesInvoice'

  validates :tila, inclusion: { in: ['L'] }

  scope :not_delivered, -> { where(alatila: %w(A C)) }
  scope :invoiced, -> { where(alatila: 'X') }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "L"
  end
end
