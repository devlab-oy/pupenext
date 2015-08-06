require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "enable_pickadate has correct elements" do
    render text: enable_pickadate

    assert_select "div[id=pickadate_data]", { count: 1, text: '' }, 'we should have one empty div'
    assert_select "#pickadate_data[data-months]", { count: 1 }, 'months data attribute required'
    assert_select "#pickadate_data[data-weekdays]", { count: 1 }, 'weekdays data attribute required'
  end
end
