require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  setup do
    @acme = companies(:acme)
  end

  test "fixture is valid" do
    assert @acme.valid?, @acme.errors.messages
  end

  test "company relations" do
    assert_not_nil @acme.parameter
    assert_not_nil @acme.accounts
    assert_not_nil @acme.currencies
    assert_not_nil @acme.keywords
    assert_not_nil @acme.users
    assert_not_nil @acme.cost_centers
    assert_not_nil @acme.projects
    assert_not_nil @acme.targets
  end

  test "company has working STI headings" do
    assert_not_nil @acme.heads
    assert_equal 5, @acme.heads.count

    assert_not_nil @acme.purchase_orders
    assert_equal Head::PurchaseOrder.new.class, @acme.purchase_orders.first.class
    assert_equal 1, @acme.purchase_orders.count
    assert_equal ['O'], @acme.purchase_orders.collect(&:tila).uniq

    assert_not_nil @acme.purchase_invoices
    assert_equal Head::PurchaseInvoice.new.class, @acme.purchase_invoices.first.class
    assert_equal 1, @acme.purchase_invoices.count
    assert_equal ['H'], @acme.purchase_invoices.collect(&:tila).uniq

    assert_not_nil @acme.sales_orders
    assert_equal Head::SalesOrder.new.class, @acme.sales_orders.first.class
    assert_equal 1, @acme.sales_orders.count
    assert_equal ['N'], @acme.sales_orders.collect(&:tila).uniq

    assert_not_nil @acme.sales_invoices
    assert_equal Head::SalesInvoice.new.class, @acme.sales_invoices.first.class
    assert_equal 1, @acme.sales_invoices.count
    assert_equal ['U'], @acme.sales_invoices.collect(&:tila).uniq

    assert_not_nil @acme.vouchers
    assert_equal Head::Voucher.new.class, @acme.vouchers.first.class
    assert_equal 1, @acme.vouchers.count
    assert_equal ['X'], @acme.vouchers.collect(&:tila).uniq
  end

  test 'company has working STI sum levels' do
    assert_not_nil @acme.sum_levels
    assert_equal 7, @acme.sum_levels.count

    assert_not_nil @acme.sum_level_internals
    assert_equal SumLevel::Internal.new.class, @acme.sum_level_internals.first.class
    assert_equal 3, @acme.sum_level_internals.count
    assert_equal ['S'], @acme.sum_level_internals.collect(&:tyyppi).uniq

    assert_not_nil @acme.sum_level_externals
    assert_equal SumLevel::External.new.class, @acme.sum_level_externals.first.class
    assert_equal 2, @acme.sum_level_externals.count
    assert_equal ['U'], @acme.sum_level_externals.collect(&:tyyppi).uniq

    assert_not_nil @acme.sum_level_vats
    assert_equal SumLevel::Vat.new.class, @acme.sum_level_vats.first.class
    assert_equal 1, @acme.sum_level_vats.count
    assert_equal ['A'], @acme.sum_level_vats.collect(&:tyyppi).uniq

    assert_not_nil @acme.sum_level_profits
    assert_equal SumLevel::Profit.new.class, @acme.sum_level_profits.first.class
    assert_equal 1, @acme.sum_level_profits.count
    assert_equal ['B'], @acme.sum_level_profits.collect(&:tyyppi).uniq
  end

  test 'get fiscal year returns fiscal year' do
    @acme.tilikausi_alku = Date.today
    @acme.tilikausi_loppu = Date.today+4
    assert_equal [Date.today, Date.today+4], @acme.get_fiscal_year
  end

  test 'method returns if given date is in this fiscal year' do
    @acme.tilikausi_alku = Date.today
    @acme.tilikausi_loppu = Date.today+4
    assert @acme.is_date_in_this_fiscal_year? Date.today+1
    refute @acme.is_date_in_this_fiscal_year? Date.today+5
    refute @acme.is_date_in_this_fiscal_year? Date.yesterday
  end

  test 'get months in current fiscal year' do
    @acme.tilikausi_alku = '01 Aug 2014'
    @acme.tilikausi_loppu = '31 Dec 2014'
    assert_equal 5, @acme.get_months_in_current_fiscal_year
  end
end
