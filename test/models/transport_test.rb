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
    @one.encoding = :utf8
    assert @one.valid?
    assert @one.utf8?
    refute @one.iso8859_15?

    @one.encoding = :iso8859_15
    assert @one.valid?
    assert @one.iso8859_15?
    refute @one.utf8?

    @one.encoding = nil
    assert @one.valid?

    assert_raises(ArgumentError) { @one.encoding = :foo }
  end
end
