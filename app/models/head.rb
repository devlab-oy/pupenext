class Head < BaseModel
  include PupenextSingleTableInheritance

  self.table_name = :lasku
  self.primary_key = :tunnus
  self.inheritance_column = :tila

  belongs_to :terms_of_payment, foreign_key: :maksuehto
  has_many :accounting_rows, class_name: 'Head::VoucherRow', foreign_key: :ltunnus

  before_create :set_date_fields
  after_create :fix_datetime_fields
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
      update_columns params
    end
end
