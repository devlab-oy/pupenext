class Company < ActiveRecord::Base
  with_options foreign_key: :yhtio, primary_key: :yhtio do |o|
    o.has_one  :parameter

    o.has_many :accounts
    o.has_many :currencies
    o.has_many :keywords
    o.has_many :users
    o.has_many :fiscal_years

    o.has_many :sum_levels
    o.has_many :sum_level_internals,   class_name: 'SumLevel::Internal'
    o.has_many :sum_level_externals,   class_name: 'SumLevel::External'
    o.has_many :sum_level_vats,        class_name: 'SumLevel::Vat'
    o.has_many :sum_level_profits,     class_name: 'SumLevel::Profit'
    o.has_many :sum_level_commodities, class_name: 'SumLevel::Commodity'

    o.has_many :heads
    o.has_many :purchase_orders,                       class_name: 'Head::PurchaseOrder'
    o.has_many :purchase_invoices_approval,            class_name: 'Head::PurchaseInvoice::Approval'
    o.has_many :purchase_invoices_paid,                class_name: 'Head::PurchaseInvoice::Paid'
    o.has_many :purchase_invoices_approved,            class_name: 'Head::PurchaseInvoice::Approved'
    o.has_many :purchase_invoices_ready_for_transfer,  class_name: 'Head::PurchaseInvoice::Transfer'
    o.has_many :purchase_invoices_waiting_for_payment, class_name: 'Head::PurchaseInvoice::Waiting'
    o.has_many :sales_orders,                          class_name: 'Head::SalesOrder'
    o.has_many :sales_invoices,                        class_name: 'Head::SalesInvoice'
    o.has_many :vouchers,                              class_name: 'Head::Voucher'
    o.has_many :voucher_rows,                          class_name: 'Head::VoucherRow'

    o.has_many :cost_centers, class_name: 'Qualifier::CostCenter'
    o.has_many :projects,     class_name: 'Qualifier::Project'
    o.has_many :targets,      class_name: 'Qualifier::Target'
  end

  has_many :commodities, class_name: 'FixedAssets::Commodity'
  has_many :commodity_rows, through: :commodities, class_name: 'FixedAssets::CommodityRow'

  # Map old database schema table to Company class
  self.table_name = :yhtio
  self.primary_key = :tunnus

  def current_fiscal_year
    fy = fiscal_years.where("tilikausi_alku <= now() and tilikausi_loppu >= now()")
    raise RuntimeError, "Tilikaudet rikki!" unless fy.count == 1

    fy.first.tilikausi_alku..fy.first.tilikausi_loppu
  end

  def fiscal_year
    [tilikausi_alku, tilikausi_loppu]
  end

  def months_in_current_fiscal_year
    (tilikausi_alku..tilikausi_loppu).map(&:end_of_month).uniq.count
  end

  def date_in_current_fiscal_year?(date)
    (tilikausi_alku..tilikausi_loppu).cover?(date)
  end

  def classic_ui?
    parameter.kayttoliittyma == 'C' || parameter.kayttoliittyma.blank?
  end
end
