class Company < ActiveRecord::Base
  with_options foreign_key: :yhtio, primary_key: :yhtio do |o|
    o.has_one  :parameter

    o.has_many :accounts
    o.has_many :currencies
    o.has_many :keywords
    o.has_many :users

    o.has_many :sum_levels
    o.has_many :sum_level_internals, class_name: 'SumLevel::Internal'
    o.has_many :sum_level_externals, class_name: 'SumLevel::External'
    o.has_many :sum_level_vats,      class_name: 'SumLevel::Vat'
    o.has_many :sum_level_profits,   class_name: 'SumLevel::Profit'

    o.has_many :heads
    o.has_many :purchase_orders,   class_name: 'Head::PurchaseOrder'
    o.has_many :purchase_invoices, class_name: 'Head::PurchaseInvoice'
    o.has_many :sales_orders,      class_name: 'Head::SalesOrder'
    o.has_many :sales_invoices,    class_name: 'Head::SalesInvoice'
    o.has_many :vouchers,          class_name: 'Head::Voucher'

    o.has_many :cost_centers, class_name: 'Qualifier::CostCenter'
    o.has_many :projects,     class_name: 'Qualifier::Project'
    o.has_many :targets,      class_name: 'Qualifier::Target'

    o.has_many :commodities, class_name: 'Accounting::FixedAssets::Commodity'
  end

  # Map old database schema table to Company class
  self.table_name = :yhtio
  self.primary_key = :tunnus

  def get_fiscal_year
    [tilikausi_alku, tilikausi_loppu]
  end

  def get_months_in_current_fiscal_year
    (tilikausi_alku..tilikausi_loppu).map{|m| m.end_of_month }.uniq.count
  end

  def is_date_in_this_fiscal_year?(date)
    (tilikausi_alku..tilikausi_loppu).cover?(date)
  end

  def classic_ui?
    parameter.kayttoliittyma == 'C' || parameter.kayttoliittyma.blank?
  end
end
