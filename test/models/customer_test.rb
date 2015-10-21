require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  fixtures %w(customers customer_prices products transports keyword/customer_subcategories)

  setup do
    @one                    = customers :stubborn_customer
    @hammer                 = products :hammer
    @helmet                 = products :helmet
    @ski                    = products :ski
    @customer_subcategory_1 = keyword_customer_subcategories :customer_subcategory_1
  end

  test 'fixtures are valid' do
    assert @one.valid?
  end

  test 'relations' do
    assert_not_equal 0, @one.transports.count
    assert @one.customer_prices.count > 0
    assert @one.products.count > 0
    assert_equal @customer_subcategory_1, @one.customer_subcategory
  end

  test 'contract_price?' do
    assert @one.contract_price?(@hammer)
    assert @one.contract_price?(@helmet)

    refute @one.contract_price?(@ski)
  end
end
