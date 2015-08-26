require 'test_helper'

class FreightContractTest < ActiveSupport::TestCase
  setup do
    @one = freight_contracts(:plane)
    @two = freight_contracts(:boat)
  end

  test "fixtures are valid" do
    assert @one.valid?, @one.errors.full_messages
    assert @two.valid?, @two.errors.full_messages
  end

  test 'relations' do
    assert_equal Customer, @one.customer.class
    assert_equal DeliveryMethod, @one.delivery_method.class
  end

  test "delivery method saved to freight contract must exist" do
    @one.toimitustapa = 'Kissa'
    refute @one.valid?
  end
end
