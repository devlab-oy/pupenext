require 'test_helper'

class Administration::DepartureHelperTest < ActionView::TestCase
  test "returns translated departure options valid for collection" do
    assert day_of_the_week_options.is_a? Array

    text = I18n.t 'administration.delivery_methods.departures.day_of_the_week_options.monday', :fi
    assert_equal text, day_of_the_week_options.first.first
    assert_equal 1, day_of_the_week_options.first.second
  end
end
