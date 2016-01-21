require 'test_helper'

class CommodityHelperTest < ActionView::TestCase
  test 'should get options for depreciation types' do
    assert_equal 4, commodity_options_for_type.count

    returned_types = commodity_options_for_type.map(&:last).sort
    all_types = [ '', 'B', 'P', 'T' ]

    assert_equal all_types, returned_types
  end

  test 'should get options for commodity statuses' do
    assert_equal 3, commodity_options_for_status.count

    returned_options = commodity_options_for_status.map(&:last).sort
    all_statuses = [ '', 'A', 'P' ]

    assert_equal all_statuses, returned_options
  end
end
