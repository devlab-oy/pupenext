require 'test_helper'

class DeliveryMethodTest < ActiveSupport::TestCase

  def setup
    @delivery_method = delivery_methods(:kaukokiito)
  end

  test "fixtures should be valid" do
    assert @delivery_method.valid?, @delivery_method.errors.messages
  end

  test "selite should be unique" do
    @delivery_method.selite = "Kiitolinja"
    refute @delivery_method.valid?, "Delivery method already exists"
  end

  test "should get waybill options" do
    assert_kind_of Array, @delivery_method.waybill_options
    assert_operator 0, '<', @delivery_method.waybill_options.count
  end

  test "should get mode of transport options" do
    assert_kind_of Array, @delivery_method.mode_of_transport_options
    assert_operator 0, '<', @delivery_method.mode_of_transport_options.count
  end
end
