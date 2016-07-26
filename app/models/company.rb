class Company < ActiveRecord::Base
  with_options foreign_key: :yhtio, primary_key: :yhtio do |o|
    o.has_one  :parameter

    o.has_many :accounts
    o.has_many :bank_accounts
    o.has_many :bank_details
    o.has_many :campaigns
    o.has_many :carriers
    o.has_many :cash_registers
    o.has_many :currencies
    o.has_many :customers
    o.has_many :customer_categories, class_name: 'Category::Customer'
    o.has_many :delivery_methods
    o.has_many :factorings
    o.has_many :fiscal_years
    o.has_many :keywords
    o.has_many :locations
    o.has_many :package_codes
    o.has_many :packages
    o.has_many :packing_areas
    o.has_many :printers
    o.has_many :shelf_locations
    o.has_many :suppliers
    o.has_many :terms_of_payments
    o.has_many :users
    o.has_many :warehouses

    o.has_many :products
    o.has_many :brands,             class_name: 'Product::Brand'
    o.has_many :categories,         class_name: 'Product::Category'
    o.has_many :product_categories, class_name: 'Category::Product'
    o.has_many :product_statuses,   class_name: 'Product::Status'
    o.has_many :product_suppliers,  class_name: 'Product::Supplier'
    o.has_many :subcategories,      class_name: 'Product::Subcategory'

    o.has_many :sum_levels
    o.has_many :sum_level_internals,   class_name: 'SumLevel::Internal'
    o.has_many :sum_level_externals,   class_name: 'SumLevel::External'
    o.has_many :sum_level_vats,        class_name: 'SumLevel::Vat'
    o.has_many :sum_level_profits,     class_name: 'SumLevel::Profit'
    o.has_many :sum_level_commodities, class_name: 'SumLevel::Commodity'

    o.has_many :heads
    o.has_many :manufacture_orders,                    class_name: 'ManufactureOrder::Order'
    o.has_many :purchase_invoices_approval,            class_name: 'Head::PurchaseInvoice::Approval'
    o.has_many :purchase_invoices_approved,            class_name: 'Head::PurchaseInvoice::Approved'
    o.has_many :purchase_invoices_paid,                class_name: 'Head::PurchaseInvoice::Paid'
    o.has_many :purchase_invoices_ready_for_transfer,  class_name: 'Head::PurchaseInvoice::Transfer'
    o.has_many :purchase_invoices_waiting_for_payment, class_name: 'Head::PurchaseInvoice::Waiting'
    o.has_many :purchase_orders,                       class_name: 'PurchaseOrder::Order'
    o.has_many :sales_invoices,                        class_name: 'Head::SalesInvoice'
    o.has_many :sales_order_drafts,                    class_name: 'SalesOrder::Draft'
    o.has_many :sales_orders,                          class_name: 'SalesOrder::Order'
    o.has_many :voucher_rows, through: :vouchers,      class_name: 'Head::VoucherRow', source: :rows
    o.has_many :vouchers,                              class_name: 'Head::Voucher'
    o.has_many :stock_transfers,                       class_name: 'StockTransfer::Order'
    o.has_many :bookkeeping_rows,                      class_name: 'Head::VoucherRow'

    o.has_many :qualifiers
    o.has_many :cost_centers, class_name: 'Qualifier::CostCenter'
    o.has_many :projects,     class_name: 'Qualifier::Project'
    o.has_many :targets,      class_name: 'Qualifier::Target'

    o.has_many :revenue_expenditures, class_name: 'Keyword::RevenueExpenditure'

    o.has_many :permissions
    o.has_many :menus, -> { where(kuka: '', profiili: '') }, class_name: 'Permission'
    o.has_many :profiles, -> { where.not(profiili: '').where('profiili = kuka') }, class_name: 'Permission'
  end

  has_many :commodities, class_name: 'FixedAssets::Commodity'
  has_many :commodity_rows, through: :commodities, class_name: 'FixedAssets::CommodityRow'
  has_many :transports, as: :transportable
  has_many :customer_transports, through: :customers, source: :transports
  has_many :mail_servers
  has_many :incoming_mails, through: :mail_servers

  accepts_nested_attributes_for :bank_accounts, :users

  self.table_name = :yhtio
  self.primary_key = :tunnus

  before_save :defaults

  validates :nimi, presence: true
  validates :yhtio, uniqueness: true

  def to_s
    "#{nimi} (#{ytunnus})"
  end

  def fiscal_year(date)
    fy = fiscal_years.where("tilikausi_alku <= :date and tilikausi_loppu >= :date", date: date)
    raise RuntimeError, "Tilikaudet rikki!" unless fy.count == 1

    fy.first.tilikausi_alku..fy.first.tilikausi_loppu
  end

  def current_fiscal_year
    fiscal_year(Date.today)
  end

  def previous_fiscal_year
    fy = fiscal_years
      .where("tilikausi_alku < ?", current_fiscal_year.first)
      .order(tilikausi_alku: :desc).limit(1)

    return if fy.empty?

    fy.first.tilikausi_alku..fy.first.tilikausi_loppu
  end

  def open_period
    [tilikausi_alku, tilikausi_loppu]
  end

  def date_in_open_period?(date)
    (open_period.first..open_period.last).cover?(date.try(:to_date))
  end

  def classic_ui?
    parameter.kayttoliittyma == 'C' || parameter.kayttoliittyma.blank?
  end

  private

    def defaults
      self.ytunnus ||= ''
      self.osoite  ||= ''
      self.postino ||= ''
      self.postitp ||= ''
    end
end
