require 'test_helper'

class Reports::DepreciationDifferenceReportTest < ActiveSupport::TestCase
  fixtures %w(
    sum_levels
  )

  setup do
    @acme = companies :acme

    @report = Reports::DepreciationDifferenceReport.new(
      company_id: @acme.id,
      start_date: Date.today.beginning_of_year.to_s,
      end_date:   Date.today.beginning_of_year,
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

    accounts = sum_levels.first.accounts
    assert_equal Array, accounts.class
    assert_equal Reports::DepreciationDifferenceReport::Account, accounts.first.class

    commodities = accounts.first.commodities
    assert_equal Array, commodities.class
    assert_equal Reports::DepreciationDifferenceReport::Commodity, commodities.first.class
  end
end
