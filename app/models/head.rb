class Head < BaseModel
  include PupenextSingleTableInheritance

  self.table_name = :lasku
  self.primary_key = :tunnus
  self.inheritance_column = :tila

  belongs_to :terms_of_payment, foreign_key: :maksuehto
  belongs_to :delivery_method, foreign_key: :toimitustapa, primary_key: :selite
  belongs_to :customer, foreign_key: :liitostunnus

  has_many :accounting_rows, class_name: 'Head::VoucherRow', foreign_key: :ltunnus
  has_one :detail, foreign_key: :otunnus, class_name: 'HeadDetail'

  delegate :laskutus_nimi,
           :laskutus_nimitark,
           :laskutus_osoite,
           :laskutus_postino,
           :laskutus_postitp,
           :laskutus_maa, to: :detail

  scope :paid, -> { where.not(mapvm: 0) }
  scope :unpaid, -> { where(mapvm: 0) }

  def self.default_child_instance
    child_class 'N'
  end

  def self.child_class_names
    {
      '9' => SalesOrder::Detail,
      'G' => StockTransfer::Order,
      'H' => Head::PurchaseInvoice::Approval,
      'L' => SalesOrder::Order,
      'M' => Head::PurchaseInvoice::Approved,
      'N' => SalesOrder::Draft,
      'O' => PurchaseOrder::Order,
      'P' => Head::PurchaseInvoice::Transfer,
      'Q' => Head::PurchaseInvoice::Waiting,
      'U' => Head::SalesInvoice,
      'V' => ManufactureOrder::Order,
      'X' => Head::Voucher,
      'K' => Arrival,
      'Y' => Head::PurchaseInvoice::Paid,
    }
  end

  def self.purchase_invoices
    where(tila: Head::PurchaseInvoice::TYPES)
  end

  def self.sales_orders
    where(tila: SalesOrder::Base::TYPES)
  end
end
