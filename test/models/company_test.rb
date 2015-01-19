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

  test "company has working STI invoices" do
    assert_not_nil @acme.heads
    assert_not_nil @acme.purchase_orders
    assert_not_nil @acme.purchase_invoices
    assert_not_nil @acme.sales_orders
    assert_not_nil @acme.sales_invoices
    assert_not_nil @acme.vouchers
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
