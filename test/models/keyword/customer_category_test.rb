require 'test_helper'

class Keyword::CustomerCategoryTest < ActiveSupport::TestCase
  fixtures %w(
    customers
    keyword/customer_categories
  )

  setup do
    @one = keyword_customer_categories :customer_category_1
    @two = keyword_customer_categories :customer_category_2
  end

  test 'fixtures are valid' do
    assert @one.valid?, @one.errors.full_messages
  end

  test 'associations work' do
    assert_equal 2, @one.customers.count
    assert_equal 0, @two.customers.count
  end
end
