class Head::VoucherRow < ActiveRecord::Base
  with_options foreign_key: :ltunnus, primary_key: :tunnus do |o|
    o.belongs_to :purchase_invoice, class_name: 'Head::PurchaseInvoice'
    o.belongs_to :purchase_order,   class_name: 'Head::PurchaseOrder'
    o.belongs_to :sales_invoice,    class_name: 'Head::SalesInvoice'
    o.belongs_to :sales_order,      class_name: 'Head::SalesOrder'
    o.belongs_to :voucher,          class_name: 'Head::Voucher'
  end

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio
  belongs_to :commodity, class_name: 'FixedAssets::Commodity'

  default_scope { where(korjattu: '') }
  scope :locked, -> { where(lukko: 'X') }
  scope :unlocked, -> { where(lukko: '') }

  validates :yhtio, presence: true
  validate :allow_only_active_fiscal_period

  before_save :defaults

  def account
    company.accounts.find_by(tilino: tilino)
  end

  def linkable?
    account.evl_taso.present?
  end

  def counter_entry(account_number)
    # Create a counter entry for self
    row = self.dup
    row.tilino = account_number
    row.summa *= -1
    row.selite += ' vastakirjaus'
    row.save!
  end

  self.table_name = :tiliointi
  self.primary_key = :tunnus

  private

    def defaults
      self.laadittu ||= Date.today
      self.korjausaika ||= Date.today
    end

    def allow_only_active_fiscal_period
      unless company.date_in_current_fiscal_year?(tapvm)
        errors.add(:base, 'Must be created in current fiscal period')
      end
    end
end
