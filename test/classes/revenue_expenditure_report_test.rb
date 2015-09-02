require 'test_helper'

class RevenueExpenditureReportTest < ActiveSupport::TestCase
  fixtures %w(heads head/voucher_rows keywords)

  setup do
    travel_to Date.parse '2015-08-14'

    si_two = heads(:si_two)
    si_two.erpcm = Date.today
    si_two.tapvm = Date.today
    si_two.mapvm = Date.today
    si_two.save

    si_two_history = heads(:si_two_history)
    si_two_history.erpcm = Time.now.weeks_ago(3)
    si_two_history.tapvm = Time.now.weeks_ago(3)
    si_two_history.save

    si_two_overdue = heads(:si_two_overdue)
    si_two_overdue.erpcm = Date.today.beginning_of_week
    si_two_overdue.tapvm = Time.now.weeks_ago(1)
    si_two_overdue.save

    si_two_factoring = heads(:si_two_factoring)
    si_two_factoring.erpcm = Date.today
    si_two_factoring.tapvm = Date.today
    si_two_factoring.mapvm = Date.today
    si_two_factoring.save

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
        week_sanitized: '33___2015',
        sales: BigDecimal(866),
        purchases: BigDecimal(56432)
      },
      {
        week: '34 / 2015',
        week_sanitized: '34___2015',
        sales: BigDecimal(0),
        purchases: BigDecimal(0)
      },
      {
        week: '35 / 2015',
        week_sanitized: '35___2015',
        sales: BigDecimal(0),
        purchases: BigDecimal(0)
      },
      {
        week: '36 / 2015',
        week_sanitized: '36___2015',
        sales: BigDecimal(0),
        purchases: BigDecimal(11000)
      },
      {
        week: '37 / 2015',
        week_sanitized: '37___2015',
        sales: BigDecimal(0),
        purchases: BigDecimal(0)
      },
      {
        week: '38 / 2015',
        week_sanitized: '38___2015',
        sales: BigDecimal(0),
        purchases: BigDecimal(0)
      },
    ]

    weekly_sum = {
      sales: BigDecimal(866),
      purchases: BigDecimal(67732)
    }

    weekly_alternative_expenditure = {
      '38 / 2015' => [
        keywords(:weekly_alternative_expenditure_one)
      ]
    }

    data = {
      history_salesinvoice: heads(:si_two_history).summa,
      history_purchaseinvoice: history_purchaseinvoice_sum,
      overdue_accounts_payable: overdue_accounts_payable_sum,
      overdue_accounts_receivable: heads(:si_two_overdue).summa,
      weekly: weekly,
      weekly_sum: weekly_sum,
      weekly_alternative_expenditure: weekly_alternative_expenditure
    }

    response = RevenueExpenditureReport.new(1).data

    assert_equal data, response
  end
end
