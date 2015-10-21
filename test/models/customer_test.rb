require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  fixtures %w(customers products transports keyword/customer_subcategories)

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
    assert_equal @customer_subcategory_1, @one.customer_subcategory
  end
end
