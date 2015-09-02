require 'test_helper'

class Keyword::RevenueExpenditureReportDataTest < ActiveSupport::TestCase
  fixtures %w(keywords)

  setup do
    @weekly = keywords(:weekly_alternative_expenditure_one)
  end

  test 'fixtures are valid' do
    assert @weekly.valid?
  end

  test 'fetch data' do
    assert_equal 1, Keyword::RevenueExpenditureReportData.all.count
  end
end
