require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  fixtures %w(
    customer_prices
    customers
    keyword/customer_subcategories
    products
    transports
  )

  setup do
    @one    = customers :stubborn_customer
    @hammer = products :hammer
    @helmet = products :helmet
    @ski    = products :ski
  end

  test 'fixtures are valid' do
    assert @one.valid?
  end

  test 'relations' do
    assert_not_equal 0, @one.transports.count
    assert_equal @customer_subcategory_1, @one.subcategory
    assert @one.prices.count > 0
    assert @one.products.count > 0
  end

  test 'contract_price?' do
    assert @one.contract_price?(@hammer)
    assert @one.contract_price?(@helmet)

    refute @one.contract_price?(@ski)
  end
end
