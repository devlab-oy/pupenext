require 'test_helper'

class KeywordHelperTest < ActionView::TestCase
  test "should get mode of transport options" do
    assert_kind_of Array, mode_of_transport_options
    assert_equal '1 - Merikuljetus (ml. auto- ja junalauttakuljetus)', mode_of_transport_options.first.first
  end

  test "should get nature of transaction options" do
    assert_kind_of Array, nature_of_transaction_options
    assert_equal '11 - Suora osto/myynti', nature_of_transaction_options.first.first
  end

  test "should get customs options" do
    assert_kind_of Array, customs_options
    assert_equal 'FI0', customs_options.first.second
  end

  test "should get sorting point options" do
    assert_kind_of Array, sorting_point_options
    assert_equal 'FIVAT', sorting_point_options.first.second
  end
end
