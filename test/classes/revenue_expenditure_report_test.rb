require 'test_helper'

class RevenueExpenditureReportTest < ActiveSupport::TestCase
  def setup
  end

  test 'initialization with wrong values' do
    assert_raise ArgumentError do
      RevenueExpenditureReport.new(nil)
    end

    assert_raise ArgumentError do
      RevenueExpenditureReport.new('')
    end
  end
end
