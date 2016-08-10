require 'test_helper'

class Reports::RevenueExpenditureTest < ActiveSupport::TestCase
  fixtures %w(
    accounts
    head/voucher_rows
    heads
  )

  setup do
    # Fetch required accounts
    invoice = heads(:si_one)

    @receivable_regular   = invoice.company.myyntisaamiset
    @receivable_factoring = invoice.company.factoringsaamiset
    @receivable_concern   = invoice.company.konsernimyyntisaamiset

    @payable_regular = invoice.company.ostovelat
    @payable_concern = invoice.company.konserniostovelat
  end

  teardown do
    # make sure other tests don't mess up our dates
    travel_back
  end

  test 'initialization with wrong values' do
    assert_raise ArgumentError do
      Reports::RevenueExpenditure.new(nil)
    end

    assert_raise ArgumentError do
      Reports::RevenueExpenditure.new('')
    end
  end

  test 'history revenue' do
    # Let's save one invoice and delete the rest
    invoice_one = heads(:si_one).dup
    Head::SalesInvoice.delete_all

    # First is unpaid
    invoice_one.alatila = 'X'
    invoice_one.erpcm = Time.zone.today - 1.week
    invoice_one.mapvm = 0
    invoice_one.save!

    # Add accounts receivable vourcher rows (and others, which should not matter)
    invoice_one.accounting_rows.create!(tilino: @receivable_regular, summa: 153.39, tapvm: invoice_one.tapvm)
    invoice_one.accounting_rows.create!(tilino: '100',   summa: 100.01, tapvm: invoice_one.tapvm)
    invoice_one.accounting_rows.create!(tilino: '200',   summa: 200.35, tapvm: invoice_one.tapvm)

    # Second invoice is paid, on correct week, should not matter
    invoice_two = invoice_one.dup
    invoice_two.erpcm = Time.zone.today - 1.week
    invoice_two.mapvm = Time.zone.today - 1.week
    invoice_two.save!

    # Add accounts receivable vourcher rows (which should not matter)
    invoice_two.accounting_rows.create!(tilino: @receivable_regular, summa: 300.05, tapvm: invoice_two.tapvm)
    invoice_two.accounting_rows.create!(tilino: @receivable_regular, summa: 100.15, tapvm: invoice_two.tapvm)
    invoice_two.accounting_rows.create!(tilino: @receivable_regular, summa: 200.20, tapvm: invoice_two.tapvm)

    # Fourth invoice is unpaid, correct week, but has company accounts receivable (should not matter)
    invoice_four = invoice_one.dup
    invoice_four.erpcm = Time.zone.today - 1.week
    invoice_four.mapvm = 0
    invoice_four.save!

    # Add concern accounts receivable vourcher rows (which should not matter)
    invoice_four.accounting_rows.create!(tilino: @receivable_concern, summa: 350.05, tapvm: invoice_four.tapvm)
    invoice_four.accounting_rows.create!(tilino: @receivable_concern, summa: 120.15, tapvm: invoice_four.tapvm)
    invoice_four.accounting_rows.create!(tilino: @receivable_concern, summa: 230.20, tapvm: invoice_four.tapvm)

    # Fifth invoice is unpaid, correct week, but has factoring receivable
    invoice_five = invoice_one.dup
    invoice_five.erpcm = Time.zone.today - 1.week
    invoice_five.mapvm = 0
    invoice_five.summa = 84.1
    invoice_five.save!

    # Add factoring receivable vourcher rows
    invoice_five.accounting_rows.create!(tilino: @receivable_factoring, summa: 29.3, tapvm: invoice_five.tapvm)
    invoice_five.accounting_rows.create!(tilino: @receivable_factoring, summa: 11.5, tapvm: invoice_five.tapvm)
    invoice_five.accounting_rows.create!(tilino: @receivable_factoring, summa: 43.3, tapvm: invoice_five.tapvm)

    # history_revenue should include invoice one and four.
    response = Reports::RevenueExpenditure.new(1).data
    assert_equal 178.62, response[:history_revenue]
  end

  test 'history expenditure' do
    # Let's save three invoices and delete the rest
    invoice_one = heads(:pi_H).dup
    invoice_two = heads(:pi_Y).dup
    invoice_three = heads(:pi_M).dup
    Head::PurchaseInvoice.delete_all

    # First is unpaid
    invoice_one.erpcm = Time.zone.today - 1.week
    invoice_one.mapvm = 0
    invoice_one.save!

    # Add accounts payable rows, these should show up, others should not
    invoice_one.accounting_rows.create!(tilino: @payable_regular, summa: -53.39, tapvm: invoice_one.tapvm)
    invoice_one.accounting_rows.create!(tilino: @payable_regular, summa: -46.61, tapvm: invoice_one.tapvm)
    invoice_one.accounting_rows.create!(tilino: @payable_concern, summa: -46.61, tapvm: invoice_one.tapvm)
    invoice_one.accounting_rows.create!(tilino: @receivable_regular, summa: -46.61, tapvm: invoice_one.tapvm)

    # Second invoice is paid
    invoice_two.mapvm = Time.zone.today - 2.days
    invoice_two.erpcm = Time.zone.today - 2.days
    invoice_two.save!

    # Add accounts payable rows, these should not show up, as invoice is paid
    invoice_two.accounting_rows.create!(tilino: @payable_regular, summa: -53.39, tapvm: invoice_two.tapvm)
    invoice_two.accounting_rows.create!(tilino: @payable_regular, summa: -46.61, tapvm: invoice_two.tapvm)
    invoice_two.accounting_rows.create!(tilino: @payable_concern, summa: -46.61, tapvm: invoice_two.tapvm)
    invoice_two.accounting_rows.create!(tilino: @receivable_regular, summa: -46.61, tapvm: invoice_two.tapvm)

    # Third is unpaid approved invoice
    invoice_three.erpcm = Time.zone.today - 1.week
    invoice_three.mapvm = 0
    invoice_three.save!

    # Add accounts payable rows, these should show up, others should not
    invoice_three.accounting_rows.create!(tilino: @payable_regular, summa: -12.14, tapvm: invoice_three.tapvm)
    invoice_three.accounting_rows.create!(tilino: @payable_regular, summa: -15.86, tapvm: invoice_three.tapvm)
    invoice_three.accounting_rows.create!(tilino: @payable_concern, summa: -46.61, tapvm: invoice_three.tapvm)
    invoice_three.accounting_rows.create!(tilino: @receivable_regular, summa: -46.61, tapvm: invoice_three.tapvm)

    # Lets add one alternative expenditure for previous week
    keyword_one = keywords(:weekly_alternative_expenditure_one)
    selite_date = Time.zone.today - 1.week
    keyword_one.selite = selite_date.strftime '%Y%V'
    keyword_one.selitetark_2 = '22.30'
    keyword_one.save!

    # history_expenditure should include invoice one and three
    response = Reports::RevenueExpenditure.new(1).data
    assert_equal 150.30, response[:history_expenditure]
  end

  test 'weekly sales' do
    # Weekly sales are grouped per week, we'll test the first/current week
    # We must travel to friday, since factoring accounts for "yesterday".
    # Otherwise these test would not work on mondays.
    this_friday = Time.zone.today.beginning_of_week.advance(days: 4)
    travel_to this_friday

    # Let's save one invoice and delete the rest
    invoice_one = heads(:si_one).dup
    Head::SalesInvoice.delete_all

    # First is unpaid, within current week, should be included
    invoice_one.erpcm = Time.zone.today
    invoice_one.mapvm = 0
    invoice_one.alatila = 'X'
    invoice_one.save!

    # Only regular accounting rows should be included
    invoice_one.accounting_rows.create!(tilino: @receivable_regular, summa: 153.39, tapvm: invoice_one.tapvm)
    invoice_one.accounting_rows.create!(tilino: @receivable_concern, summa: 543.39, tapvm: invoice_one.tapvm)

    # sales should be 153.39
    response = Reports::RevenueExpenditure.new(1).data
    assert_equal 153.39, response[:weekly][0][:sales].to_f

    # Second invoice unpaid, but due last week, should not be included
    invoice_two = invoice_one.dup
    invoice_two.erpcm = Time.zone.today - 1.week
    invoice_two.tapvm = Time.zone.today - 2.weeks
    invoice_two.mapvm = 0
    invoice_two.save!

    # None of these should be included
    invoice_two.accounting_rows.create!(tilino: @receivable_regular, summa: 53.39, tapvm: invoice_two.tapvm)
    invoice_two.accounting_rows.create!(tilino: @receivable_factoring, summa: 53.39, tapvm: invoice_two.tapvm)
    invoice_two.accounting_rows.create!(tilino: @receivable_concern, summa: 53.39, tapvm: invoice_two.tapvm)

    # sales should be 153.39
    response = Reports::RevenueExpenditure.new(1).data
    assert_equal 153.39, response[:weekly][0][:sales].to_f

    # Third invoice is overdue factoring
    # only 30% of account row's sum is added
    # overdue date is on current week, but event date is not
    invoice_three = invoice_one.dup
    invoice_three.erpcm = Time.zone.today
    invoice_three.tapvm = Time.zone.today - 1.week
    invoice_three.save!

    # 30% of factoring rows should be included (222 * 0.3 = 66.6)
    invoice_three.accounting_rows.create!(tilino: @receivable_factoring, summa: 222, tapvm: invoice_three.tapvm)
    invoice_three.accounting_rows.create!(tilino: @receivable_concern, summa: 53.39, tapvm: invoice_three.tapvm)

    # sales should be 153.39 + 66.6
    response = Reports::RevenueExpenditure.new(1).data
    assert_equal 219.99, response[:weekly][0][:sales].to_f

    # Fourth invoice is factoring, due 1 week from now. event date is yesterday
    # we should include 70% of factoring rows based on event date
    invoice_four = invoice_one.dup
    invoice_four.erpcm = Time.zone.today + 1.week
    invoice_four.tapvm = Time.zone.today - 1.day
    invoice_four.save!

    # 70% of facatoring rows should be included (42 * 0.7 = 29.4) * 2 = 58.8
    invoice_four.accounting_rows.create!(tilino: @receivable_factoring, summa: 42, tapvm: invoice_four.tapvm)
    invoice_four.accounting_rows.create!(tilino: @receivable_factoring, summa: 42, tapvm: invoice_four.tapvm)
    invoice_four.accounting_rows.create!(tilino: @receivable_concern, summa: 53.39, tapvm: invoice_four.tapvm)

    # sales should be 153.39 + 66.6 + 58.8
    response = Reports::RevenueExpenditure.new(1).data
    assert_equal 278.79, response[:weekly][0][:sales].to_f
  end

  test 'weekly purchases' do
    # weekly purchases consists of
    # - purchases
    # - alternative expenditures

    # Let's save one invoice and delete the rest
    invoice_one = heads(:pi_H).dup
    Head::PurchaseInvoice.delete_all

    # Let's save one keyword and delete the rest
    keyword_one = keywords(:weekly_alternative_expenditure_one).dup
    Keyword::RevenueExpenditure.delete_all

    # First invoice is unpaid within current week
    invoice_one.erpcm = Time.zone.today
    invoice_one.mapvm = 0
    invoice_one.alatila = 'X'
    invoice_one.save!

    # Only regular accounting rows should be included (300.0)
    invoice_one.accounting_rows.create!(tilino: @payable_regular, summa: -153.39, tapvm: invoice_one.tapvm)
    invoice_one.accounting_rows.create!(tilino: @payable_regular, summa: -146.61, tapvm: invoice_one.tapvm)
    invoice_one.accounting_rows.create!(tilino: @payable_concern, summa: -543.39, tapvm: invoice_one.tapvm)

    # We should have 300
    response = Reports::RevenueExpenditure.new(1).data
    assert_equal 300, response[:weekly][0][:purchases].to_f

    # Second invoice is unpaid, outside of current week
    invoice_two = invoice_one.dup
    invoice_two.erpcm = Time.zone.today - 1.week
    invoice_two.save!

    # Nothing should be included
    invoice_two.accounting_rows.create!(tilino: @payable_regular, summa: -153.39, tapvm: invoice_two.tapvm)
    invoice_two.accounting_rows.create!(tilino: @payable_regular, summa: -146.61, tapvm: invoice_two.tapvm)
    invoice_two.accounting_rows.create!(tilino: @payable_concern, summa: -543.39, tapvm: invoice_two.tapvm)

    # We should have 300 + 0
    response = Reports::RevenueExpenditure.new(1).data
    assert_equal 300, response[:weekly][0][:purchases].to_f

    current_week = "#{Time.zone.today.cweek} / #{Time.zone.today.year}"
    assert_equal current_week, response[:weekly][0][:week]

    # Lets add one alternative expenditure for current week
    # this should be added to purchases
    keyword_one.selite = Time.zone.today.strftime '%Y%V'
    keyword_one.selitetark_2 = '100'
    keyword_one.save!

    # Lets add another one alternative expenditure for next week
    # Should not be added to purchases
    keyword_two = keyword_one.dup
    keyword_two.selite = 1.week.from_now.to_date.strftime '%Y%V'
    keyword_two.selitetark_2 = '100'
    keyword_two.save!

    # we should have 300 + 100
    response = Reports::RevenueExpenditure.new(1).data
    assert_equal 400, response[:weekly][0][:purchases].to_f
  end

  test 'weekly company group accounts receivable' do
    # Let's save one invoice and delete the rest
    invoice_one = heads(:si_one).dup
    Head::SalesInvoice.delete_all

    # First is unpaid and within current week
    invoice_one.erpcm = Time.zone.today
    invoice_one.mapvm = 0
    invoice_one.alatila = 'X'
    invoice_one.save!

    # Only concern rows should be included
    invoice_one.accounting_rows.create!(tilino: @receivable_regular, summa: 300.05, tapvm: invoice_one.tapvm)
    invoice_one.accounting_rows.create!(tilino: @receivable_regular, summa: 100.15, tapvm: invoice_one.tapvm)
    invoice_one.accounting_rows.create!(tilino: @receivable_concern, summa: 200.20, tapvm: invoice_one.tapvm)

    # we should have 200.20
    response = Reports::RevenueExpenditure.new(1).data
    assert_equal 200.20, response[:weekly][0][:concern_accounts_receivable].to_f

    # Second invoice is outside of current week
    invoice_two = invoice_one.dup
    invoice_two.erpcm = Time.zone.today - 1.week
    invoice_two.save!

    # none of this should be included
    invoice_two.accounting_rows.create!(tilino: @receivable_regular, summa: 300.05, tapvm: invoice_two.tapvm)
    invoice_two.accounting_rows.create!(tilino: @receivable_regular, summa: 100.15, tapvm: invoice_two.tapvm)
    invoice_two.accounting_rows.create!(tilino: @receivable_concern, summa: 200.20, tapvm: invoice_two.tapvm)

    # we should have 200.20
    response = Reports::RevenueExpenditure.new(1).data
    assert_equal 200.20, response[:weekly][0][:concern_accounts_receivable].to_f
  end

  test 'weekly company group accounts payable' do
    # Let's save one invoice and delete the rest
    invoice_one = heads(:pi_H).dup
    Head::PurchaseInvoice.delete_all

    # First invoice is sent, unpaid, and due this week
    invoice_one.erpcm = Time.zone.today
    invoice_one.mapvm = 0
    invoice_one.alatila = 'X'
    invoice_one.save!

    # Concern accounting rows should be included (666,73)
    invoice_one.accounting_rows.create!(tilino: @payable_regular, summa: -153.39, tapvm: invoice_one.tapvm)
    invoice_one.accounting_rows.create!(tilino: @payable_regular, summa: -146.61, tapvm: invoice_one.tapvm)
    invoice_one.accounting_rows.create!(tilino: @payable_concern, summa: -543.39, tapvm: invoice_one.tapvm)
    invoice_one.accounting_rows.create!(tilino: @payable_concern, summa: -123.34, tapvm: invoice_one.tapvm)

    # concern accounts payable should include invoice one
    response = Reports::RevenueExpenditure.new(1).data
    assert_equal 666.73, response[:weekly][0][:concern_accounts_payable].to_f

    # Second invoice is sent, unpaid, but outside of current week
    invoice_two = invoice_one.dup
    invoice_two.erpcm = Time.zone.today - 1.week
    invoice_two.save!

    # Nothing should be included
    invoice_two.accounting_rows.create!(tilino: @payable_regular, summa: -153.39, tapvm: invoice_two.tapvm)
    invoice_two.accounting_rows.create!(tilino: @payable_regular, summa: -146.61, tapvm: invoice_two.tapvm)
    invoice_two.accounting_rows.create!(tilino: @payable_concern, summa: -543.39, tapvm: invoice_two.tapvm)
    invoice_two.accounting_rows.create!(tilino: @payable_concern, summa: -123.34, tapvm: invoice_two.tapvm)

    # concern accounts payable should include invoice one
    response = Reports::RevenueExpenditure.new(1).data
    assert_equal 666.73, response[:weekly][0][:concern_accounts_payable].to_f
  end

  test 'weekly alternative expenditures' do
    # Lets add one alternative expenditure for current week
    keyword_one = keywords(:weekly_alternative_expenditure_one)
    keyword_one.selite = Time.zone.today.strftime '%Y%V'
    keyword_one.selitetark_2 = '53.39'
    keyword_one.save!

    # Should not sum this keyword's amount
    keyword_two = keyword_one.dup
    keyword_two.selite = 1.week.from_now.to_date.strftime '%Y%V'
    keyword_two.selitetark_2 = '100'
    keyword_two.save!

    response = Reports::RevenueExpenditure.new(1).data
    assert_equal 53.39, response[:weekly][0][:alternative_expenditures][0][:amount].to_f
  end

  test 'should return data per week' do
    # Let's travel to a static date, so we know how many weeks to expect
    travel_to Date.parse '2015-08-14'

    response = Reports::RevenueExpenditure.new(1).data
    assert_equal 5, response[:weekly].count

    response = Reports::RevenueExpenditure.new(2).data
    assert_equal 9, response[:weekly].count
  end

  test 'week numbers when week 1 is in the middle of the week' do
    travel_to Date.parse '2016-12-19'

    response = Reports::RevenueExpenditure.new(1).data
    weeks = response[:weekly].map { |week| week[:week] }

    assert_equal '51 / 2016', weeks.first,  'first should be week 51'
    assert_equal '52 / 2016', weeks.second, 'second should be week 52'
    assert_equal '01 / 2017', weeks.third,  'third should be week 1'
  end
end
