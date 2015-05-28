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

  test "should not allow unifaun with build patch print" do
    @delivery_method.tulostustapa = "L"
    @delivery_method.rahtikirja = "rahtikirja_unifaun_foo_bar"

    refute @delivery_method.valid?, @delivery_method.errors.messages
  end

  test "should allow unifaun" do
    @delivery_method.tulostustapa = "H"
    @delivery_method.rahtikirja = "rahtikirja_unifaun_foo_bar"
    assert @delivery_method.valid?, @delivery_method.errors.messages
  end
end
