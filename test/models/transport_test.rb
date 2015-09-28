require 'test_helper'

class TransportTest < ActiveSupport::TestCase
  fixtures %w(transports customers)

  setup do
    @one = transports :one
    @two = transports :two
  end

  test 'fixtures are valid' do
    assert @one.valid?
    assert @two.valid?
  end

  test 'relation' do
    assert_equal Customer, @one.customer.class
  end
end
