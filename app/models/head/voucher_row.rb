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

  validates :yhtio, presence: true

  validate :allow_only_active_fiscal_period

  default_scope { where(korjattu: '') }

  def allow_only_active_fiscal_period
    unless company.date_in_current_fiscal_year?(tapvm)
      errors.add(:base, 'Must be created in current fiscal period')
    end
  end

  def self.locked
    where(lukko: 'X')
  end

  def self.unlocked
    where(lukko: '')
  end

  def account
    company.accounts.find_by(tilino: tilino)
  end

  self.table_name = :tiliointi
  self.primary_key = :tunnus

  before_save :defaults

  private

    def defaults
      self.laadittu ||= Date.today
      self.korjausaika ||= Date.today
    end
end
