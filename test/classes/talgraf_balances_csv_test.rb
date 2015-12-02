require 'test_helper'

class TalgrafBalancesCsvTest < ActiveSupport::TestCase
  fixtures %w(
    accounts
    fiscal_years
    qualifiers
  )

  setup do
    @company = companies :acme

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

    # should find proper qualifiers from qualifiers section
    output = "dimension,999999,New project\n"
    assert report.csv_data.lines.include? output
  end
end
