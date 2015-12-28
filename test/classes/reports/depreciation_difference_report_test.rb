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
      group_by:   :sum_level,
    )
  end

  test 'class' do
    assert_not_nil @report
  end

  test 'required relations' do
    assert @acme.sum_level_commodities.count > 0
  end
end
