require 'test_helper'

class Administration::DepartureHelperTest < ActionView::TestCase
  test "returns translated departure options valid for collection" do
    assert day_of_the_week_options.is_a? Array

    text = I18n.t 'administration.delivery_methods.departures.day_of_the_week_options.monday', :fi
    assert_equal text, day_of_the_week_options.first.first
    assert_equal 1, day_of_the_week_options.first.second
  end

  test "returns terminal area options valid for collection" do
    assert terminal_area_options.is_a? Array

    assert_equal 'Lastauslaituri', terminal_area_options.first.first
    assert_equal 'LASTAUS', terminal_area_options.first.second
  end

  test "returns customer category options valid for collection" do
    assert customer_category_options.is_a? Array

    assert_equal 'Täysi-ikäinen', customer_category_options.first.first
    assert_equal '18', customer_category_options.first.second
  end

  test "returns warehouse options valid for collection" do
    assert warehouse_options.is_a? Array

    assert_equal 'Veikkolan varasto', warehouse_options.first.first
  end

  test "returns status options valid for collection" do
    assert status_options.is_a? Array

    text = I18n.t 'administration.delivery_methods.departures.status_options.not_in_use', :fi
    assert_equal text, status_options.second.first
    assert_equal :not_in_use, status_options.second.second
  end
end
