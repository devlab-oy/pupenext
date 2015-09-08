require 'test_helper'

class RevenueExpenditureReportTest < ActiveSupport::TestCase
  fixtures %w(heads head/voucher_rows accounts)

  teardown do
    # make sure other tests don't mess up our dates
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
    # sales accounting row sums are negative for accounting reasons
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
    # purchase accounting row sums are positive for accounting reasons
    invoice_one.accounting_rows.create!(tilino: '345', summa: 53.39, tapvm: 1.weeks.ago)

    # Second invoice is paid
    invoice_two = invoice_one.dup
    invoice_two.mapvm = 2.weeks.ago
    invoice_two.erpcm = 2.weeks.ago
    invoice_two.summa = 324.34
    invoice_two.save!

    # Create accounting rows
    # purchase accounting row sums are positive for accounting reasons
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

    # We must travel to friday, since accounts payable calculated between monday - yesterday.
    # Otherwise these test would not work on mondays.
    this_friday = Date.today.beginning_of_week.advance(days: 4)
    travel_to this_friday

    # First is unpaid and within current week
    invoice_one.erpcm = 1.days.ago
    invoice_one.mapvm = 0
    invoice_one.save!

    # Create accounting rows
    # purchase accounting row sums are positive for accounting reasons
    invoice_one.accounting_rows.create!(tilino: '345', summa: 53.39, tapvm: 1.weeks.ago)

    # Second invoice is unpaid, but its overdue date is last week
    # sum is calculated as 0
    invoice_two = invoice_one.dup
    invoice_two.erpcm = 1.weeks.ago
    invoice_two.mapvm = 0
    invoice_two.save!

    # Create accounting rows
    # purchase accounting row sums are positive for accounting reasons
    invoice_two.accounting_rows.create!(tilino: '345', summa: 12.34, tapvm: 2.weeks.ago)

    # Third invoice is paid
    invoice_three = invoice_one.dup
    invoice_three.erpcm = 1.days.ago
    invoice_three.mapvm = 1.days.ago
    invoice_three.save!

    # Create accounting rows
    # purchase accounting row sums are positive for accounting reasons
    invoice_three.accounting_rows.create!(tilino: '345', summa: 100, tapvm: 2.weeks.ago)

    # overdue_accounts_payable should include invoice one
    response = RevenueExpenditureReport.new(1).data
    assert_equal 53.39, response[:overdue_accounts_payable].to_f
  end

  test 'overdue accounts receivable' do
    # Let's save one invoice and delete the rest
    invoice_one = heads(:si_one).dup
    Head::SalesInvoice.delete_all

    # We must travel to friday, since accounts receivable calculated between monday - yesterday.
    # Otherwise these test would not work on mondays.
    this_friday = Date.today.beginning_of_week.advance(days: 4)
    travel_to this_friday

    # First is unpaid and within current week
    invoice_one.erpcm = 1.days.ago
    invoice_one.mapvm = 0
    invoice_one.save!

    # Create accounting rows
    # sales accounting row sums are negative for accounting reasons
    invoice_one.accounting_rows.create!(tilino: '345', summa: -53.39, tapvm: 1.weeks.ago)

    # Second invoice is unpaid, but its overdue date is last week
    # sum is calculated as 0
    invoice_two = invoice_one.dup
    invoice_two.erpcm = 1.weeks.ago
    invoice_two.mapvm = 0
    invoice_two.save!

    # Create accounting rows
    # sales accounting row sums are negative for accounting reasons
    invoice_two.accounting_rows.create!(tilino: '345', summa: -12.34, tapvm: 2.weeks.ago)

    # Third invoice is paid
    invoice_three = invoice_one.dup
    invoice_three.erpcm = 1.days.ago
    invoice_three.mapvm = 1.days.ago
    invoice_three.save!

    # Create accounting rows
    # sales accounting row sums are negative for accounting reasons
    invoice_three.accounting_rows.create!(tilino: '345', summa: -100, tapvm: 2.weeks.ago)

    # Fourth invoice is unpaid but with factoring account number
    invoice_four = invoice_one.dup
    invoice_four.erpcm = 1.days.ago
    invoice_four.mapvm = 0
    invoice_four.save!

    # Create accounting rows
    # sales accounting row sums are negative for accounting reasons
    invoice_four.accounting_rows.create!(tilino: '666', summa: -100, tapvm: 2.weeks.ago)

    # overdue_accounts_receivable should include invoice one
    response = RevenueExpenditureReport.new(1).data
    assert_equal 53.39, response[:overdue_accounts_receivable].to_f
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
    # sales accounting row sums are negative for accounting reasons
    invoice_one.accounting_rows.create!(tilino: '345', summa: -53.39, tapvm: 1.weeks.ago)

    # Second invoice is outside of current week
    invoice_two = invoice_one.dup
    invoice_two.alatila = 'X'
    invoice_two.erpcm = 1.weeks.ago
    invoice_two.save!

    # Create accounting rows
    # sales accounting row sums are negative for accounting reasons
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
    # sales accounting row sums are negative for accounting reasons
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
    # sales accounting row sums are negative for accounting reasons
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
    # purchase accounting row sums are positive for accounting reasons
    invoice_one.accounting_rows.create!(tilino: '345', summa: 53.39, tapvm: 1.weeks.ago)

    # Second invoice is outside of current week
    invoice_two = invoice_one.dup
    invoice_two.alatila = 'X'
    invoice_two.erpcm = 1.weeks.ago
    invoice_two.save!

    # Create accounting rows
    # purchase accounting row sums are positive for accounting reasons
    invoice_two.accounting_rows.create!(tilino: '345', summa: 20, tapvm: 1.weeks.ago)

    # Lets add one alternative expenditure for current week
    keyword_one = keywords(:weekly_alternative_expenditure_one)
    keyword_one.selite = "#{Date.today.cweek} / #{Date.today.year}"
    keyword_one.selitetark_2 = '100'
    keyword_one.save!

    # Lets add another one alternative expenditure for next week
    # Should not sum this keyword's amount
    keyword_two = keyword_one.dup
    keyword_two.selite = "#{1.week.from_now.to_date.cweek} / #{1.week.from_now.year}"
    keyword_two.selitetark_2 = '100'
    keyword_two.save!

    # purchases should include invoice one
    response = RevenueExpenditureReport.new(1).data
    assert_equal 153.39, response[:weekly][0][:purchases].to_f
  end

  test 'weekly company group accounts receivable' do
    # Let's save one invoice and delete the rest
    invoice_one = heads(:si_one).dup
    Head::SalesInvoice.delete_all

    # First is within current week
    # Can be either paid or unpaid
    invoice_one.erpcm = Date.today
    invoice_one.alatila = 'X'
    invoice_one.save!

    # Create accounting rows
    # sales accounting row sums are positive for accounting reasons
    invoice_one.accounting_rows.create!(tilino: '999', summa: 53.39, tapvm: 1.weeks.ago)

    # Second invoice is outside of current week
    invoice_two = invoice_one.dup
    invoice_two.erpcm = 1.weeks.ago
    invoice_two.save!

    # Create accounting rows
    # sales accounting row sums are positive for accounting reasons
    invoice_two.accounting_rows.create!(tilino: '999', summa: 20, tapvm: 1.weeks.ago)

    # concern accounts receivable should include invoice one
    response = RevenueExpenditureReport.new(1).data
    assert_equal 53.39, response[:weekly][0][:concern_accounts_receivable].to_f
  end

  test 'weekly company group accounts payable' do
    # Let's save one invoice and delete the rest
    invoice_one = heads(:pi_H).dup
    Head::PurchaseInvoice.delete_all

    # First is within current week
    # Can be either paid or unpaid
    invoice_one.erpcm = Date.today
    invoice_one.save!

    # Create accounting rows
    # purchase accounting row sums are positive for accounting reasons
    invoice_one.accounting_rows.create!(tilino: '777', summa: 53.39, tapvm: 1.weeks.ago)

    # Second invoice is outside of current week
    invoice_two = invoice_one.dup
    invoice_two.erpcm = 1.weeks.ago
    invoice_two.save!

    # Create accounting rows
    # purchase accounting row sums are positive for accounting reasons
    invoice_two.accounting_rows.create!(tilino: '777', summa: 20, tapvm: 1.weeks.ago)

    # concern accounts payable should include invoice one
    response = RevenueExpenditureReport.new(1).data
    assert_equal 53.39, response[:weekly][0][:concern_accounts_payable].to_f
  end

  test 'weekly alternative expenditures' do
    # Lets add one alternative expenditure for current week
    keyword_one = keywords(:weekly_alternative_expenditure_one)
    keyword_one.selite = "#{Date.today.cweek} / #{Date.today.year}"
    keyword_one.selitetark_2 = '53.39'
    keyword_one.save!

    # Should not sum this keyword's amount
    keyword_two = keyword_one.dup
    keyword_two.selite = "#{1.week.from_now.to_date.cweek} / #{1.week.from_now.year}"
    keyword_two.selitetark_2 = '100'
    keyword_two.save!

    response = RevenueExpenditureReport.new(1).data
    assert_equal 53.39, response[:weekly][0][:alternative_expenditures][0][:amount].to_f
  end

  test 'should return data per week' do
    response = RevenueExpenditureReport.new(1).data
    assert_equal 5, response[:weekly].count

    response = RevenueExpenditureReport.new(2).data
    assert_equal 9, response[:weekly].count
  end
end
