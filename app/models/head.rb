class Head < BaseModel
  include PupenextSingleTableInheritance

  self.table_name = :lasku
  self.primary_key = :tunnus
  self.inheritance_column = :tila

  belongs_to :terms_of_payment, foreign_key: :maksuehto
  has_many :accounting_rows, class_name: 'Head::VoucherRow', foreign_key: :ltunnus

  # We have actually 5 types, that are saved in "tila".
  # Eventough it's supposed to be the STI column.
  PURCHASE_INVOICE_TYPES = %w{H Y M P Q}

  scope :paid, -> { where.not(mapvm: '0000-00-00') }
  scope :unpaid, -> { where(mapvm: '0000-00-00') }
  scope :all_purchase_invoices, -> { where(tila: PURCHASE_INVOICE_TYPES) }

  def self.default_child_instance
    child_class 'N'
  end

  def self.child_class_names
    {
      'H' => Head::PurchaseInvoice::Approval,
      'Y' => Head::PurchaseInvoice::Paid,
      'M' => Head::PurchaseInvoice::Approved,
      'P' => Head::PurchaseInvoice::Transfer,
      'Q' => Head::PurchaseInvoice::Waiting,
      'O' => Head::PurchaseOrder,
      'U' => Head::SalesInvoice,
      'N' => Head::SalesOrderDraft,
      'L' => Head::SalesOrder,
      'X' => Head::Voucher,
    }
  end
end
