require 'test_helper'

class RevenueExpenditureReportTest < ActiveSupport::TestCase
  fixtures %w(heads head/voucher_rows accounts)

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

    si_concern_receivable = heads(:si_concern_receivable)
    si_concern_receivable.erpcm = Date.today
    si_concern_receivable.tapvm = Date.today
    si_concern_receivable.mapvm = Date.today
    si_concern_receivable.save

    pi_concern_payable = heads(:pi_concern_payable)
    pi_concern_payable.erpcm = Date.today
    pi_concern_payable.tapvm = Date.today
    pi_concern_payable.mapvm = Date.today
    pi_concern_payable.save

    Head::PurchaseInvoice::PURCHASE_INVOICE_TYPES.each do |i|
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

  test 'should return revenue expenditure data' do
    history_purchaseinvoice_sum = 0
    overdue_accounts_payable_sum = 0

    Head::PurchaseInvoice::PURCHASE_INVOICE_TYPES.each do |i|
      history_purchaseinvoice_sum += heads(:"pi_#{i}_history").summa
      overdue_accounts_payable_sum += heads(:"pi_#{i}_overdue").summa
    end

    weekly = [
      {
        week: '33 / 2015',
        week_sanitized: '33___2015',
        sales: 866.0,
        purchases: 56432.0,
        concern_accounts_receivable: heads(:si_concern_receivable).summa,
        concern_accounts_payable: heads(:pi_concern_payable).summa,
        alternative_expenditures: [],
      },
      {
        week: '34 / 2015',
        week_sanitized: '34___2015',
        sales: 0.0,
        purchases: 0.0,
        concern_accounts_receivable: 0.0,
        concern_accounts_payable: 0.0,
        alternative_expenditures: [],
      },
      {
        week: '35 / 2015',
        week_sanitized: '35___2015',
        sales: 0.0,
        purchases: 0.0,
        concern_accounts_receivable: 0.0,
        concern_accounts_payable: 0.0,
        alternative_expenditures: [],
      },
      {
        week: '36 / 2015',
        week_sanitized: '36___2015',
        sales: 0.0,
        purchases: 11000.0,
        concern_accounts_receivable: 0.0,
        concern_accounts_payable: 0.0,
        alternative_expenditures: [],
      },
      {
        week: '37 / 2015',
        week_sanitized: '37___2015',
        sales: 0.0,
        purchases: 0.0,
        concern_accounts_receivable: 0.0,
        concern_accounts_payable: 0.0,
        alternative_expenditures: [],
      },
      {
        week: '38 / 2015',
        week_sanitized: '38___2015',
        sales: 0.0,
        purchases: 0.0,
        concern_accounts_receivable: 0.0,
        concern_accounts_payable: 0.0,
        alternative_expenditures: [
          { description: 'Palkat', amount: '300' }
        ],
      },
    ]

    weekly_sum = {
      sales: 866.0,
      purchases: 67732.0,
      concern_accounts_receivable: 999.0,
      concern_accounts_payable: 333.0,
    }

    alternative_expenditure = keywords(:weekly_alternative_expenditure_one)

    weekly.each do |w|
      if w[:week] == alternative_expenditure.selite
        w[:purchases] += alternative_expenditure.selitetark_2.to_f
      end
    end

    data = {
      history_salesinvoice: heads(:si_two_history).summa,
      history_purchaseinvoice: history_purchaseinvoice_sum,
      overdue_accounts_payable: overdue_accounts_payable_sum,
      overdue_accounts_receivable: heads(:si_two_overdue).summa,
      weekly: weekly,
      weekly_sum: weekly_sum,
    }

    response = RevenueExpenditureReport.new(1).data

    assert_equal data[:history_salesinvoice],        response[:history_salesinvoice]
    assert_equal data[:history_purchaseinvoice],     response[:history_purchaseinvoice]
    assert_equal data[:overdue_accounts_payable],    response[:overdue_accounts_payable]
    assert_equal data[:overdue_accounts_receivable], response[:overdue_accounts_receivable]
    assert_equal data[:weekly],                      response[:weekly]
    assert_equal data[:weekly_sum],                  response[:weekly_sum]
    assert_equal data, response
  end

  test 'unpaid sent sales invoices' do
    # Let's save one invoice and delete the rest
    invoice_one = heads(:si_one).dup
    Head::SalesInvoice.delete_all

    # First is unpaid
    invoice_one.erpcm = 1.weeks.ago
    invoice_one.alatila = 'X'
    invoice_one.mapvm = 0
    invoice_one.save!

    # Create accounting rows
    # sales sums are negative for accounting reasons
    invoice_one.accounting_rows.create!(tilino: '555', summa: -53.39, tapvm: 1.weeks.ago)

    # Second invoice is paid
    invoice_two = invoice_one.dup
    invoice_two.mapvm = 2.weeks.ago
    invoice_two.erpcm = 2.weeks.ago
    invoice_two.summa = 324.34
    invoice_two.save!

    # Fourth invoice is company accounts receivable
    invoice_four = invoice_one.dup
    invoice_four.mapvm = 0
    invoice_four.erpcm = 1.weeks.ago
    invoice_four.summa = 123.2
    invoice_four.save!
    invoice_four.accounting_rows.create!(tilino: '999', summa: -100, tapvm: 1.weeks.ago)

    # Fifth invoice is factoring
    invoice_five = invoice_one.dup
    invoice_five.mapvm = 0
    invoice_five.erpcm = 1.weeks.ago
    invoice_five.summa = 123.2
    invoice_five.save!
    invoice_five.accounting_rows.create!(tilino: '666', summa: -100, tapvm: 1.weeks.ago)

    # history_salesinvoice should include invoice one and four.
    response = RevenueExpenditureReport.new(1).data
    assert_equal 153.39, response[:history_salesinvoice]
  end

  test 'unpaid purchase invoices' do
    # Let's save one invoice and delete the rest
    invoice_one = heads(:pi_H).dup
    Head::PurchaseInvoice.delete_all

    # First is unpaid
    invoice_one.erpcm = 1.weeks.ago
    invoice_one.mapvm = 0
    invoice_one.save!

    # Create accounting rows
    # sales sums are positive for accounting reasons
    invoice_one.accounting_rows.create!(tilino: '345', summa: 53.39, tapvm: 1.weeks.ago)

    # Second invoice is paid
    invoice_two = invoice_one.dup
    invoice_two.mapvm = 2.weeks.ago
    invoice_two.erpcm = 2.weeks.ago
    invoice_two.summa = 324.34
    invoice_two.save!

    # Create accounting rows
    # row sums are positive for accounting reasons
    invoice_two.accounting_rows.create!(tilino: '345', summa: 12.34, tapvm: 2.weeks.ago)

    # Third invoice is company accounts payable
    invoice_three = invoice_one.dup
    invoice_three.mapvm = 0
    invoice_three.erpcm = 1.weeks.ago
    invoice_three.summa = 100.0
    invoice_three.save!
    invoice_three.accounting_rows.create!(tilino: '777', summa: 100, tapvm: 1.weeks.ago)

    # history_purchaseinvoice should include invoice one and three
    response = RevenueExpenditureReport.new(1).data
    assert_equal 153.39, response[:history_purchaseinvoice]
  end

  test 'overdue accounts payable' do
    # Let's save one invoice and delete the rest
    invoice_one = heads(:pi_H).dup
    Head::PurchaseInvoice.delete_all

    # First is unpaid and within current week
    invoice_one.erpcm = 1.days.ago #Date.today is 2015-08-14, friday because of setup travel_to
    invoice_one.mapvm = 0
    invoice_one.save!

    # Create accounting rows
    # sales sums are positive for accounting reasons
    invoice_one.accounting_rows.create!(tilino: '345', summa: 53.39, tapvm: 1.weeks.ago)

    # Second invoice is unpaid, but it is current date so it's not overdue
    # sum is calculated as 0
    invoice_two = invoice_one.dup
    invoice_two.erpcm = Date.today
    invoice_two.mapvm = 0
    invoice_two.save!

    # Create accounting rows
    # row sums are positive for accounting reasons
    invoice_two.accounting_rows.create!(tilino: '345', summa: 12.34, tapvm: 2.weeks.ago)

    # Third invoice is paid
    invoice_three = invoice_one.dup
    invoice_three.erpcm = 1.days.ago
    invoice_three.mapvm = 1.days.ago
    invoice_three.save!

    # Create accounting rows
    # row sums are positive for accounting reasons
    invoice_three.accounting_rows.create!(tilino: '345', summa: 100, tapvm: 2.weeks.ago)

    # overdue_accounts_payable should include invoice one
    response = RevenueExpenditureReport.new(1).data
    assert_equal 53.39, response[:overdue_accounts_payable]
  end

  test 'overdue accounts receivable' do
    # Let's save one invoice and delete the rest
    invoice_one = heads(:si_one).dup
    Head::SalesInvoice.delete_all

    # First is unpaid and within current week
    invoice_one.erpcm = 1.days.ago #Date.today is 2015-08-14, friday because of setup travel_to
    invoice_one.mapvm = 0
    invoice_one.save!

    # Create accounting rows
    # sales sums are negative for accounting reasons
    invoice_one.accounting_rows.create!(tilino: '345', summa: -53.39, tapvm: 1.weeks.ago)

    # Second invoice is unpaid, but it is current date so it's not overdue
    # sum is calculated as 0
    invoice_two = invoice_one.dup
    invoice_two.erpcm = Date.today
    invoice_two.mapvm = 0
    invoice_two.save!

    # Create accounting rows
    # row sums are negative for accounting reasons
    invoice_two.accounting_rows.create!(tilino: '345', summa: -12.34, tapvm: 2.weeks.ago)

    # Third invoice is paid
    invoice_three = invoice_one.dup
    invoice_three.erpcm = 1.days.ago
    invoice_three.mapvm = 1.days.ago
    invoice_three.save!

    # Create accounting rows
    # row sums are negative for accounting reasons
    invoice_three.accounting_rows.create!(tilino: '345', summa: -100, tapvm: 2.weeks.ago)

    # Fourth invoice is unpaid but with factoring account number
    invoice_four = invoice_one.dup
    invoice_four.erpcm = 1.days.ago
    invoice_four.mapvm = 0
    invoice_four.save!

    # Create accounting rows
    # row sums are negative for accounting reasons
    invoice_four.accounting_rows.create!(tilino: '666', summa: -100, tapvm: 2.weeks.ago)

    # overdue_accounts_receivable should include invoice one
    response = RevenueExpenditureReport.new(1).data
    assert_equal 53.39, response[:overdue_accounts_receivable]
  end

  test 'weekly sales' do
    # weekly sales consists of
    # - sales
    # - current week overdue factoring (current date is thursday, mon-wed factorings are overdue)
    # - current week factoring

    # Let's save one invoice and delete the rest
    invoice_one = heads(:si_one).dup
    Head::SalesInvoice.delete_all

    # First is within current week
    # Can be either paid or unpaid
    invoice_one.erpcm = Date.today
    invoice_one.alatila = 'X'
    invoice_one.save!

    # Create accounting rows
    # row sums are negative for accounting reasons
    invoice_one.accounting_rows.create!(tilino: '345', summa: -53.39, tapvm: 1.weeks.ago)

    # Second invoice is outside of current week
    invoice_two = invoice_one.dup
    invoice_two.alatila = 'X'
    invoice_two.erpcm = 1.weeks.ago
    invoice_two.save!

    # Create accounting rows
    # row sums are negative for accounting reasons
    invoice_two.accounting_rows.create!(tilino: '345', summa: -20, tapvm: 1.weeks.ago)

    # Third invoice is overdue factoring
    # only 30% of account row's sum is added
    # overdue date is on current week, but event date is not
    invoice_three = invoice_one.dup
    invoice_three.erpcm = 1.days.ago
    invoice_three.tapvm = 1.weeks.ago
    invoice_three.alatila = 'X'
    invoice_three.save!

    # Create accounting rows
    # Factoring account number is 666 from accounts.yml
    # row sums are negative for accounting reasons
    invoice_three.accounting_rows.create!(tilino: '666', summa: -100, tapvm: 1.days.ago)

    # Fourth invoice is current week factoring
    # only 70% of account row's sum is added
    invoice_four = invoice_one.dup
    invoice_four.erpcm = Date.today
    invoice_four.tapvm = Date.today
    invoice_four.alatila = 'X'
    invoice_four.save!

    # Create accounting rows
    # Factoring account number is 666 from accounts yml
    # row sums are negative for accounting reasons
    invoice_four.accounting_rows.create!(tilino: '666', summa: -100, tapvm: 1.days.ago)

    # sales should include invoice one
    response = RevenueExpenditureReport.new(1).data
    assert_equal 153.39, response[:weekly][0][:sales].to_f
  end

  test 'weekly purchases' do
    # weekly purchases consists of
    # - purchases
    # - alternative expenditures

    # Let's save one invoice and delete the rest
    invoice_one = heads(:pi_H).dup
    Head::PurchaseInvoice.delete_all

    # First is within current week
    # Can be either paid or unpaid
    invoice_one.erpcm = Date.today
    invoice_one.alatila = 'X'
    invoice_one.save!

    # Create accounting rows
    # row sums are negative for accounting reasons
    invoice_one.accounting_rows.create!(tilino: '345', summa: 53.39, tapvm: 1.weeks.ago)

    # Second invoice is outside of current week
    invoice_two = invoice_one.dup
    invoice_two.alatila = 'X'
    invoice_two.erpcm = 1.weeks.ago
    invoice_two.save!

    # Create accounting rows
    # row sums are negative for accounting reasons
    invoice_two.accounting_rows.create!(tilino: '345', summa: 20, tapvm: 1.weeks.ago)

    # Lets add one alternative expenditure for current week
    keyword_one = keywords(:weekly_alternative_expenditure_one).dup
    keyword_one.selite = '33 / 2015'
    keyword_one.selitetark_2 = '100'
    keyword_one.save!

    # Lets add another one alternative expenditure for next week
    # Should not sum this keyword's amount
    keyword_one = keywords(:weekly_alternative_expenditure_one).dup
    keyword_one.selite = '34 / 2015'
    keyword_one.selitetark_2 = '100'
    keyword_one.save!

    # sales should include invoice one
    response = RevenueExpenditureReport.new(1).data
    assert_equal 153.39, response[:weekly][0][:purchases].to_f
  end

  test 'weekly company group accounts receivable' do
  end

  test 'weekly company group accounts payable' do
  end

  test 'weekly alternative expenditures' do
  end

  test 'should return data per week' do
    response = RevenueExpenditureReport.new(1).data
    assert_equal 4, response[:weekly].count

    response = RevenueExpenditureReport.new(2).data
    assert_equal 8, response[:weekly].count
  end

  test 'data format' do
  end
end
