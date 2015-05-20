require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  fixtures :all

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
    assert_not_nil @acme.commodities
    assert_not_nil @acme.fiscal_years
  end

  test "company has working STI headings" do
    assert_not_nil @acme.heads
    assert_equal 14, @acme.heads.count

    assert_not_nil @acme.purchase_orders
    assert_equal Head::PurchaseOrder.new.class, @acme.purchase_orders.first.class
    assert_equal 1, @acme.purchase_orders.count
    assert_equal ['O'], @acme.purchase_orders.collect(&:tila).uniq

    assert_not_nil @acme.purchase_invoices_approval
    assert_equal Head::PurchaseInvoice::Approval.new.class, @acme.purchase_invoices_approval.first.class
    assert_equal 1, @acme.purchase_invoices_approval.count
    assert_equal ['H'], @acme.purchase_invoices_approval.collect(&:tila).uniq

    assert_not_nil @acme.purchase_invoices_paid
    assert_equal Head::PurchaseInvoice::Paid.new.class, @acme.purchase_invoices_paid.first.class
    assert_equal 2, @acme.purchase_invoices_paid.count
    assert_equal ['Y'], @acme.purchase_invoices_paid.collect(&:tila).uniq

    assert_not_nil @acme.purchase_invoices_approved
    assert_equal Head::PurchaseInvoice::Approved.new.class, @acme.purchase_invoices_approved.first.class
    assert_equal 1, @acme.purchase_invoices_approved.count
    assert_equal ['M'], @acme.purchase_invoices_approved.collect(&:tila).uniq

    assert_not_nil @acme.purchase_invoices_ready_for_transfer
    assert_equal Head::PurchaseInvoice::Transfer.new.class, @acme.purchase_invoices_ready_for_transfer.first.class
    assert_equal 1, @acme.purchase_invoices_ready_for_transfer.count
    assert_equal ['P'], @acme.purchase_invoices_ready_for_transfer.collect(&:tila).uniq

    assert_not_nil @acme.purchase_invoices_waiting_for_payment
    assert_equal Head::PurchaseInvoice::Waiting.new.class, @acme.purchase_invoices_waiting_for_payment.first.class
    assert_equal 1, @acme.purchase_invoices_waiting_for_payment.count
    assert_equal ['Q'], @acme.purchase_invoices_waiting_for_payment.collect(&:tila).uniq

    assert_not_nil @acme.sales_orders
    assert_equal Head::SalesOrder.new.class, @acme.sales_orders.first.class
    assert_equal 2, @acme.sales_orders.count
    assert_equal ['N'], @acme.sales_orders.collect(&:tila).uniq

    assert_not_nil @acme.sales_invoices
    assert_equal Head::SalesInvoice.new.class, @acme.sales_invoices.first.class
    assert_equal 1, @acme.sales_invoices.count
    assert_equal ['U'], @acme.sales_invoices.collect(&:tila).uniq

    assert_not_nil @acme.vouchers
    assert_equal Head::Voucher.new.class, @acme.vouchers.first.class
    assert_equal 2, @acme.vouchers.count
    assert_equal ['X'], @acme.vouchers.collect(&:tila).uniq
  end

  test 'company has working STI sum levels' do
    assert_not_nil @acme.sum_levels
    assert_equal 9, @acme.sum_levels.count

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
    assert_equal [Date.today, Date.today+4], @acme.open_period
  end

  test 'should return current fiscal year' do
    fy = Date.today.beginning_of_year..Date.today.end_of_year
    assert_equal fy, @acme.current_fiscal_year

    assert_equal '2014-01-01'.to_date, @acme.fiscal_year('2014-06-01').first
    assert_equal '2014-12-31'.to_date, @acme.fiscal_year('2014-06-01').last

    assert_equal Date.today.beginning_of_year, @acme.current_fiscal_year.first
    assert_equal Date.today.end_of_year, @acme.current_fiscal_year.last

    params = {
      tilikausi_alku: Date.today.beginning_of_year,
      tilikausi_loppu: Date.today.end_of_year
    }

    fy = fiscal_years(:one).dup
    fy.attributes = params
    assert fy.save

    assert_raise RuntimeError do
      @acme.reload.current_fiscal_year
    end
  end

  test 'date in open period' do
    @acme.tilikausi_alku = '2014-01-01'
    @acme.tilikausi_loppu = '2014-12-31'

    assert @acme.date_in_open_period?('2014-01-01'), 'first'
    assert @acme.date_in_open_period?('2014-06-01'), 'middle'
    assert @acme.date_in_open_period?('2014-12-31'), 'last'

    assert @acme.date_in_open_period?('2014-01-01'.to_date), 'first'
    assert @acme.date_in_open_period?('2014-06-01'.to_date), 'middle'
    assert @acme.date_in_open_period?('2014-12-31'.to_date), 'last'
  end
end
