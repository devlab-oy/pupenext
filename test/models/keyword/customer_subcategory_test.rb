require 'test_helper'

class Keyword::CustomerSubcategoryTest < ActiveSupport::TestCase
  fixtures %w(
    customers
    keyword/customer_subcategories
  )

  setup do
    @one = keyword_customer_subcategories :customer_subcategory_1
    @two = keyword_customer_subcategories :customer_subcategory_2
  end

  test 'fixtures are valid' do
    assert @one.valid?, @one.errors.full_messages
  end

  test 'associations work' do
    assert_equal 2, @one.customers.count
    assert_equal 0, @two.customers.count
  end
end
