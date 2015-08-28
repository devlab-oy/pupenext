require 'test_helper'

class RevenueExpenditureReportTest < ActiveSupport::TestCase
  fixtures %w(heads head/voucher_rows)

  setup do
    travel_to Date.parse '2015-08-14'

    si_one = heads(:si_one)
    si_one.erpcm = Date.today
    si_one.tapvm = Date.today
    si_one.mapvm = Date.today
    si_one.save

    si_one_history = heads(:si_one_history)
    si_one_history.erpcm = Time.now.weeks_ago(3)
    si_one_history.tapvm = Time.now.weeks_ago(3)
    si_one_history.save

    si_one_overdue = heads(:si_one_overdue)
    si_one_overdue.erpcm = Date.today.beginning_of_week
    si_one_overdue.tapvm = Time.now.weeks_ago(1)
    si_one_overdue.save

    Head::PURCHASE_INVOICE_TYPES.each do |i|
      pi_today = heads(:"pi_#{i}")
      pi_today.erpcm = Date.today
      pi_today.tapvm = Date.today
      pi_today.mapvm = Date.today
      pi_today.save

      pi_history = heads(:"pi_#{i}_history")
      pi_history.erpcm = Time.now.weeks_ago(3)
      pi_history.tapvm = Time.now.weeks_ago(3)
      pi_history.save

      pi_overdue = heads(:"pi_#{i}_overdue")
      pi_overdue.erpcm = Date.today.beginning_of_week
      pi_overdue.tapvm = Time.now.weeks_ago(1)
      pi_overdue.save
    end
  end

  teardown do
    travel_back
  end

  test 'initialization with wrong values' do
    assert_raise ArgumentError do
      RevenueExpenditureReport.new(nil)
    end

    assert_raise ArgumentError do
      RevenueExpenditureReport.new('')
    end
  end

  test 'should return revenue / expenditure data' do
    history_purchaseinvoice_sum = 0
    overdue_accounts_payable_sum = 0
    Head::PURCHASE_INVOICE_TYPES.each do |i|
      history_purchaseinvoice_sum += heads(:"pi_#{i}_history").summa
      overdue_accounts_payable_sum += heads(:"pi_#{i}_overdue").summa
    end

    weekly = [
      {
        week: '33 / 2015',
        sales: BigDecimal(200),
        purchases: BigDecimal(54932)
      },
      {
        week: '34 / 2015',
        sales: BigDecimal(0),
        purchases: BigDecimal(0)
      },
      {
        week: '35 / 2015',
        sales: BigDecimal(0),
        purchases: BigDecimal(11000)
      },
      {
        week: '36 / 2015',
        sales: BigDecimal(0),
        purchases: BigDecimal(0)
      },
      {
        week: '37 / 2015',
        sales: BigDecimal(0),
        purchases: BigDecimal(0)
      },
      {
        week: '38 / 2015',
        sales: BigDecimal(0),
        purchases: BigDecimal(0)
      },
    ]

    data = {
      history_salesinvoice: heads(:si_one_history).summa,
      history_purchaseinvoice: history_purchaseinvoice_sum,
      overdue_accounts_payable: overdue_accounts_payable_sum,
      overdue_accounts_receivable: heads(:si_one_overdue).summa,
      weekly: weekly
    }

    response = RevenueExpenditureReport.new(1).data

    assert_equal data, response
  end
end
