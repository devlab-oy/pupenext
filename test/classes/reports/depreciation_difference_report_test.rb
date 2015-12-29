require 'test_helper'

class Reports::DepreciationDifferenceReportTest < ActiveSupport::TestCase
  fixtures %w(
    accounts
    fiscal_years
    fixed_assets/commodities
    fixed_assets/commodity_rows
    head/voucher_rows
    heads
    qualifiers
    sum_levels
  )

  setup do
    @acme = companies :acme

    @report = Reports::DepreciationDifferenceReport.new(
      company_id: @acme.id,
      start_date: Date.today.beginning_of_year.to_s,
      end_date:   Date.today.end_of_year,
    )
  end

  test 'class' do
    assert_not_nil @report
  end

  test 'required relations' do
    assert @acme.sum_level_commodities.count > 0
  end

  test 'returns response hierarcy' do
    data = @report.data
    assert_equal Reports::DepreciationDifferenceReport::Response, data.class

    sum_levels = data.sum_levels
    assert_equal Array, sum_levels.class
    assert_equal Reports::DepreciationDifferenceReport::SumLevel, sum_levels.first.class
    assert_equal "Koneet ja kalusto", sum_levels.first.name

    accounts = sum_levels.first.accounts
    assert_equal Array, accounts.class
    assert_equal Reports::DepreciationDifferenceReport::Account, accounts.first.class
    assert_equal "EVL poistoerovastatili", accounts.first.name

    commodities = accounts.first.commodities
    assert_equal Array, commodities.class

    commodity = commodities.first
    assert_equal Reports::DepreciationDifferenceReport::Commodity, commodity.class
    assert_equal "This is a commodity!", commodity.name
    assert_equal "0.0", commodity.deprication.to_s
    assert_equal "111.0", commodity.difference.to_s
    assert_equal "1001.0", commodity.evl.to_s
  end
end
