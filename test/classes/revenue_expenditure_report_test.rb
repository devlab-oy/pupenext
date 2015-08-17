require 'test_helper'

class RevenueExpenditureReportTest < ActiveSupport::TestCase
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
    Head::PurchaseInvoice::INVOICE_TYPES.each do |i|
      history_purchaseinvoice_sum += heads(:"pi_#{i}_history").summa
      overdue_accounts_payable_sum += heads(:"pi_#{i}_overdue").summa
    end

    # Example:
    # weekly = [
    #   {
    #     week: '33 / 2015',
    #     sales: BigDecimal(100),
    #     purchases: BigDecimal(500)
    #   },
    #   {
    #     week: '34 / 2015',
    #     sales: BigDecimal(0),
    #     purchases: BigDecimal(0)
    #   },
    #   {
    #     week: '35 / 2015',
    #     sales: BigDecimal(0),
    #     purchases: BigDecimal(0)
    #   },
    #   ...
    # ]

    weeks = []
    Date.today.beginning_of_week.upto(Date.today.months_since(1)) do |date|
      weeks << "#{date.cweek} / #{date.cwyear}"
    end
    weeks.uniq!

    weekly = []
    weeks.map do |week_year|
      weekly << {
        week: week_year,
        sales: BigDecimal(0),
        purchases: BigDecimal(0)
      }
    end

    weekly.first[:sales] = BigDecimal(100)
    weekly.first[:purchases] = BigDecimal(500)

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
