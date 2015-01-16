class Company < ActiveRecord::Base
  with_options foreign_key: :yhtio, primary_key: :yhtio do |o|
    o.has_one  :parameter

    o.has_many :accounts
    o.has_many :currency
    o.has_many :keywords
    o.has_many :purchase_orders
    o.has_many :users

    o.has_many :sum_levels
    o.has_many :sum_level_internals, class_name: 'SumLevel::Internal'
    o.has_many :sum_level_externals, class_name: 'SumLevel::External'
    o.has_many :sum_level_vats,      class_name: 'SumLevel::Vat'
    o.has_many :sum_level_profits,   class_name: 'SumLevel::Profit'

    o.has_many :cost_centers, class_name: 'Qualifier::CostCenter'
    o.has_many :projects,     class_name: 'Qualifier::Project'
    o.has_many :targets,      class_name: 'Qualifier::Target'

    o.has_many :accounting_vouchers,                 class_name: 'Accounting::Voucher'
    o.has_many :accounting_rows,                     class_name: 'Accounting::Row'
    o.has_many :accounting_attachments,              class_name: 'Accounting::Attachment'
    o.has_many :accounting_fixed_assets_commodities, class_name: 'Accounting::FixedAssets::Commodity'
    o.has_many :accounting_fixed_assets_rows,        class_name: 'Accounting::FixedAssets::Row'
    o.has_many :accounting_accounts,                 class_name: 'Accounting::Account'
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
