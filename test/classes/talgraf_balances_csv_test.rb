require 'test_helper'

class TalgrafBalancesCsvTest < ActiveSupport::TestCase
  fixtures %w(
    accounts
    fiscal_years
    qualifiers
    heads
  )

  setup do
    @company = companies :acme
    @previous_fiscal = fiscal_years :one
    @current_fiscal = fiscal_years :two

    project = qualifiers(:project_in_use).dup
    project.nimi = 'New project'
    project.tunnus = 999999
    project.koodi = '789'
    project.save!
  end

  test 'report initialize' do
    assert TalgrafBalancesCsv.new(company_id: @company.id, period_beginning: "2012")
    assert_raises { TalgrafBalancesCsv.new }
    assert_raises { TalgrafBalancesCsv.new company_id: nil }
    assert_raises { TalgrafBalancesCsv.new company_id: -1 }
  end

  test 'report output' do
    report = TalgrafBalancesCsv.new(company_id: @company.id, period_beginning: "2015")

    # should find info row from header section
    output = "info,Balances 2015\n"
    assert report.csv_data.lines.include? output

    # should find company id from company section
    output = "id,#{@company.ytunnus}\n"
    assert report.csv_data.lines.include? output

    # should find proper dates from accounting period section
    output = "period,#{Date.today.beginning_of_year},#{Date.today.end_of_year}\n"
    assert report.csv_data.lines.include? output

    output = "period,#{Date.today.beginning_of_year - 1.year},#{Date.today.end_of_year - 1.year}\n"
    assert report.csv_data.lines.include? output

    # should find proper accounts from accounts section
    output = "account,4444,EVL poistoerovastatili,balance\n"
    assert report.csv_data.lines.include? output

    # qualifiers section
    output = "dimension,K,Kustannuspaikka\n"
    assert report.csv_data.lines.include? output

    # accounting unit section
    output = "unit,P,999999,New project\n"
    assert report.csv_data.lines.include? output
  end

  test 'balance data' do
    report = TalgrafBalancesCsv::BalanceData.new company: @company, current_fiscal: @current_fiscal, previous_fiscal: @previous_fiscal

    row = ['BEGIN', 'BalanceData']
    assert_equal row, report.send(:header_row)

    row = ['entry-months', '2014-1', '2015-12']
    assert_equal row, report.send(:entry_months)

    row = ['ei', Date.today.beginning_of_year, 990.50, "1000", 0, 0, 0, 123456, 'Opening balance']
    assert_equal row, report.send(:opening_balance_rows).first

    row = ['e', Date.today, 1234, "100", 0, 0, 0, 7890123, 'Another']
    assert_equal row, report.send(:voucher_rows).first

    row = ['END']
    assert_equal row, report.send(:footer_row)

    # make sure we return data in right order
    # assert_equal report.send(:header_row), report.data.first
    # assert_equal report.send(:entry_months), report.data.second

  end
end
