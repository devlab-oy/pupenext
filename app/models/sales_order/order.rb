class SalesOrder::Order < SalesOrder::Base
  has_many :installments, foreign_key: :otunnus
  has_one :invoice, foreign_key: :laskunro, primary_key: :laskunro, class_name: 'Head::SalesInvoice'

  validates :tila, inclusion: { in: ['L'] }

  scope :not_delivered, -> { where(alatila: %w(A C)) }
  scope :invoiced, -> { where(alatila: 'X') }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "L"
  end
end
