require 'test_helper'

class TransportTest < ActiveSupport::TestCase
  fixtures %w(transports customers)

  setup do
    @one = transports :one
    @two = transports :two
    @three = transports :three
  end

  test 'fixtures are valid' do
    assert @one.valid?
    assert @two.valid?
    assert @three.valid?
  end

  test 'relation' do
    assert_equal Customer, @one.transportable.class
    assert_equal Customer, @two.transportable.class
    assert_equal Company, @three.transportable.class
  end

  test 'encoding values' do
    @one.encoding = "UTF-8"
    assert @one.valid?

    @one.encoding = 'ISO-8859-15'
    assert @one.valid?

    @one.encoding = nil
    assert @one.valid?

    @one.encoding = 'foo'
    refute @one.valid?
  end
end
