require 'test_helper'

class TalgrafBalancesCsvTest < ActiveSupport::TestCase
  fixtures %w(
    accounts
    fiscal_years
    head/voucher_rows
    heads
    qualifiers
  )

  setup do
    @company = companies :acme
    @previous_fiscal = fiscal_years :one
    @current_fiscal = fiscal_years :two

    @company.tilikausi_alku = Date.today.beginning_of_year
    @company.tilikausi_loppu = Date.today.end_of_year

    project = qualifiers(:project_in_use).dup
    project.nimi = 'New project'
    project.tunnus = 999999
    project.koodi = '789'
    project.save!
  end

  test 'report initialize' do
    assert TalgrafBalancesCsv.new(company_id: @company.id)
    assert_raises { TalgrafBalancesCsv.new }
    assert_raises { TalgrafBalancesCsv.new company_id: nil }
    assert_raises { TalgrafBalancesCsv.new company_id: -1 }
  end

  test 'header' do
    report = TalgrafBalancesCsv::Header.new(company: @company)

    row = ["file_version", 0]
    assert_equal row, report.send(:file_version)

    row = ['tgi-id', 'Intime']
    assert_equal row, report.send(:tgi_id)

    row = ['info', "Balances #{Date.today.year}"]
    assert_equal row, report.send(:info)

    # make sure we return data in right order
    assert_equal report.send(:header_row),   report.rows.first
    assert_equal report.send(:file_version), report.rows.second
    assert_equal report.send(:tgi_id),       report.rows[2]
    assert_equal report.send(:timestamp),    report.rows[3]
    assert_equal report.send(:info),         report.rows[4]
    assert_equal report.send(:footer_row),   report.rows.last
  end

  test 'company' do
    report = TalgrafBalancesCsv::Company.new(company: @company)

    row = ["id", @company.ytunnus]
    assert_equal row, report.send(:id)

    row = ['name', @company.nimi]
    assert_equal row, report.send(:name)

    # make sure we return data in right order
    assert_equal report.send(:header_row),   report.rows.first
    assert_equal report.send(:id), report.rows.second
    assert_equal report.send(:name),       report.rows[2]
    assert_equal report.send(:footer_row),   report.rows.last
  end

  test 'accounting periods' do
    report = TalgrafBalancesCsv::AccountingPeriods.new(company: @company)

    row = ["period", @company.tilikausi_alku, @company.tilikausi_loppu]
    assert_equal row, report.send(:period, start: @company.tilikausi_alku, stop: @company.tilikausi_loppu)

    # make sure we return data in right order
    assert_equal report.send(:header_row), report.rows.first
    assert_equal report.send(:period, start: @company.tilikausi_alku, stop: @company.tilikausi_loppu), report.rows.second
    assert_equal report.send(:footer_row), report.rows.last
  end

  test 'accounts' do
    report = TalgrafBalancesCsv::Accounts.new(company: @company)

    acco = @company.accounts.balance_sheet_accounts.order(:tilino).first
    row = ["account", acco.tilino, acco.nimi, "balance"]
    assert_equal row, report.send(:balance_sheet).first

    acco = @company.accounts.profit_and_loss_accounts.order(:tilino).first
    row = ["account", acco.tilino, acco.nimi, "closing"]
    assert_equal row, report.send(:profit_and_loss).first

    # make sure we return data in right order
    assert_equal report.send(:header_row),            report.rows.first
    assert_equal report.send(:balance_sheet).first,   report.rows.second
    assert_equal report.send(:profit_and_loss).last,  report.rows[-2]
    assert_equal report.send(:footer_row),            report.rows.last
  end

  test 'dimensions' do
    report = TalgrafBalancesCsv::Dimensions.new(company: @company)

    row = ["dimension", 'K', "Kustannuspaikka"]
    assert_equal row, report.send(:cost_centers).first

    row = ["dimension", 'P', "Projekti"]
    assert row, report.send(:projects).first

    row = ["dimension", 'O', "Kohde"]
    assert row, report.send(:targets).first

    # make sure we return data in right order
    assert_equal report.send(:header_row),         report.rows.first
    assert_equal report.send(:cost_centers).first, report.rows.second
    assert_equal report.send(:projects).first,     report.rows[2]
    assert_equal report.send(:targets).first,      report.rows[3]
    assert_equal report.send(:footer_row),         report.rows.last
  end

  test 'accounting units' do
    report = TalgrafBalancesCsv::AccountingUnits.new(company: @company)

    cost_center = qualifiers(:cost_center_in_use)
    project     = qualifiers(:project_in_use)
    target      = qualifiers(:target_in_use)

    row = ["unit", cost_center.tyyppi, cost_center.tunnus, cost_center.nimi]
    assert_equal row, report.send(:cost_centers).first

    row = ["unit", project.tyyppi, project.tunnus, project.nimi]
    assert row, report.send(:projects).first

    row = ["unit", target.tyyppi, target.tunnus, target.nimi]
    assert row, report.send(:targets).first

    # make sure we return data in right order
    assert_equal report.send(:header_row),         report.rows.first
    assert_equal report.send(:cost_centers).first, report.rows.second
    assert_equal report.send(:projects).first,     report.rows[2]
    assert_equal report.send(:targets).last,       report.rows[-2]
    assert_equal report.send(:footer_row),         report.rows.last
  end

  test 'balance data' do
    report = TalgrafBalancesCsv::BalanceData.new company: @company

    row = ['BEGIN', 'BalanceData']
    assert_equal row, report.send(:header_row)

    row = ['entry-months', "#{Date.today.year - 1}-01", "#{Date.today.year}-12"]
    assert_equal row, report.send(:entry_months)

    row = ['ei', Date.today.beginning_of_year, 990.50, "1000", 0, 0, 0, 123456, 'Opening balance']
    assert_equal row, report.send(:opening_balance_rows).first

    row = ['e', Date.today, 1234, "100", 0, 0, 0, 7890123, 'Another']
    assert_equal row, report.send(:voucher_rows).first

    row = ['END']
    assert_equal row, report.send(:footer_row)

    # make sure we return data in right order
    assert_equal report.send(:header_row),                 report.rows.first
    assert_equal report.send(:entry_months),               report.rows.second
    assert_equal report.send(:opening_balance_rows).first, report.rows[2]
    assert_equal report.send(:voucher_rows).first,         report.rows[3]
    assert_equal report.send(:footer_row),                 report.rows.last
  end

  test 'report output' do
    year_in_data = Date.today.year
    report = TalgrafBalancesCsv.new(company_id: @company.id, column_separator: '|')
    output = "info|Balances #{year_in_data}\n"
    assert report.csv_data.lines.include? output
    assert File.open(report.to_file, "rb").read.include? output

    report = TalgrafBalancesCsv.new(company_id: @company.id, column_separator: ';')
    output = "info;Balances #{year_in_data}\n"
    assert report.csv_data.lines.include? output
    assert File.open(report.to_file, "rb").read.include? output

    report = TalgrafBalancesCsv.new(company_id: @company.id)

    # should find info row from header section
    output = "info,Balances #{year_in_data}\n"
    assert report.csv_data.lines.include? output
    assert File.open(report.to_file, "rb").read.include? output

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

    # balance data section
    output = "entry-months,#{year_in_data - 1}-01,#{year_in_data}-12\n"
    assert report.csv_data.lines.include? output
  end
end
