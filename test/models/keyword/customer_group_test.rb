require 'test_helper'

class Keyword::CustomerGroupTest < ActiveSupport::TestCase
  fixtures %w(
    customers
    keyword/customer_groups
  )

  setup do
    @reipas = keyword_customer_groups :reipas
    @laiska = keyword_customer_groups :laiska
  end

  test 'fixtures are valid' do
    assert @reipas.valid?, @reipas.errors.full_messages
    assert @laiska.valid?, @laiska.errors.full_messages
  end

  test 'associations work' do
    assert_equal 1, @reipas.customers.count
    assert_equal 0, @laiska.customers.count
  end
end
