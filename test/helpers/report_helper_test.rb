require 'test_helper'

class ReportHelperTest < ActionView::TestCase
  test "returns translated month options valid for collection" do
    assert month_options.is_a? Array

    text = I18n.t "reports.revenue_expenditure_month", count: 1
    assert_equal text, month_options.first.first
    assert_equal '1', month_options.first.second
  end
end
