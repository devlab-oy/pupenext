require 'test_helper'

class CustomerPriceTest < ActiveSupport::TestCase
  fixtures %w(
    customer_prices
    customers
    products
  )

  setup do
    @one               = customer_prices(:one)
    @hammer            = products(:hammer)
    @stubborn_customer = customers(:stubborn_customer)
  end

  test "fixtures are valid" do
    assert @one.valid?, @one.errors.full_messages
  end

  test "associations work" do
    assert_equal @hammer, @one.product
    assert_equal @stubborn_customer, @one.customer
  end
end
