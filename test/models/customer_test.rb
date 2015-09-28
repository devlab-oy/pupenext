require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  fixtures %w(customers transports)

  setup do
    @one = customers :stubborn_customer
  end

  test 'fixtures are valid' do
    assert @one.valid?
  end

  test 'relations' do
    assert_not_equal 0, @one.transports.count
  end
end
