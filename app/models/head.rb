class Head < BaseModel
  include PupenextSingleTableInheritance

  self.table_name = :lasku
  self.primary_key = :tunnus
  self.inheritance_column = :tila

  belongs_to :terms_of_payment, foreign_key: :maksuehto
  belongs_to :delivery_method, foreign_key: :toimitustapa, primary_key: :selite
  has_many :accounting_rows, class_name: 'Head::VoucherRow', foreign_key: :ltunnus
  has_many :details, foreign_key: :otunnus, class_name: 'HeadDetail'

  scope :paid, -> { where.not(mapvm: 0) }
  scope :unpaid, -> { where(mapvm: 0) }

  before_create :set_date_fields
  after_create :fix_datetime_fields

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
      'Y' => Head::PurchaseInvoice::Paid,
    }
  end

  def self.purchase_invoices
    where(tila: Head::PurchaseInvoice::TYPES)
  end

  def self.sales_orders
    where(tila: SalesOrder::Base::TYPES)
  end

  private

    def set_date_fields
      # Date fields can be set to zero
      self.erpcm      ||= 0
      self.kapvm      ||= 0
      self.lapvm      ||= 0
      self.mapvm      ||= 0
      self.olmapvm    ||= 0
      self.tapvm      ||= 0
      self.toimaika   ||= 0

      # Datetime fields don't accept zero, so let's set them to epoch zero (temporarily)
      self.h1time     ||= Time.at(0)
      self.h2time     ||= Time.at(0)
      self.h3time     ||= Time.at(0)
      self.h4time     ||= Time.at(0)
      self.h5time     ||= Time.at(0)
      self.kerayspvm  ||= Time.at(0)
      self.lahetepvm  ||= Time.at(0)
      self.laskutettu ||= Time.at(0)
      self.maksuaika  ||= Time.at(0)
      self.popvm      ||= Time.at(0)
    end

    def fix_datetime_fields
      params  = {}
      zero    = '0000-00-00 00:00:00'
      epoch   = Time.at(0)

      # Change all datetime fields to zero if they are epoch
      params[:h1time]     = zero if h1time     == epoch
      params[:h2time]     = zero if h2time     == epoch
      params[:h3time]     = zero if h3time     == epoch
      params[:h4time]     = zero if h4time     == epoch
      params[:h5time]     = zero if h5time     == epoch
      params[:kerayspvm]  = zero if kerayspvm  == epoch
      params[:lahetepvm]  = zero if lahetepvm  == epoch
      params[:laskutettu] = zero if laskutettu == epoch
      params[:maksuaika]  = zero if maksuaika  == epoch
      params[:popvm]      = zero if popvm      == epoch

      # update_columns skips all validations and updates values directly with sql
      update_columns params if params.present?
    end
end
