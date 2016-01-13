require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  fixtures %w(
    customer_prices
    customers
    keyword/customer_categories
    keyword/customer_groups
    keyword/customer_subcategories
    products
    transports
  )

  setup do
    @one                    = customers :stubborn_customer
    @hammer                 = products :hammer
    @helmet                 = products :helmet
    @ski                    = products :ski
    @customer_category_1    = keyword_customer_categories :customer_category_1
    @customer_subcategory_1 = keyword_customer_subcategories :customer_subcategory_1
    @reipas                 = keyword_customer_groups :reipas
  end

  test 'fixtures are valid' do
    assert @one.valid?
  end

  test 'relations' do
    assert_equal 2, @one.transports.count
    assert_equal @customer_category_1, @one.category
    assert_equal @customer_subcategory_1, @one.subcategory
    assert_equal @reipas, @one.group
    assert @one.prices.count > 0
    assert @one.products.count > 0
  end

  test 'contract_price?' do
    assert @one.contract_price?(@hammer)
    assert @one.contract_price?(@helmet)

    refute @one.contract_price?(@ski)
  end
end
