require 'test_helper'

class CompanyTest < ActiveSupport::TestCase

  def setup
    @acme = companies(:acme)
  end

  test "fixture is valid" do
    assert @acme.valid?, @acme.errors.messages
  end

  test "company has users" do
    assert_not_nil @acme.users
  end

  test "company has parameter(s)" do
    assert_not_nil @acme.parameter
  end

  test "company has working STI headers" do
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
