require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  setup do
    @customer = customers :stubborn_customer
  end

  test "fixtures are valid" do
    assert @customer.valid?
  end

  test 'relations' do
    assert_equal 2, @customer.freight_contracts.count
  end
end
