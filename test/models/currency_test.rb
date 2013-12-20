require 'test_helper'

class CurrencyTest < ActiveSupport::TestCase

  def setup
    @currency = currencies(:currency1)
  end

  test 'should be valid nimi' do
    @currency.nimi = 'TES'
    assert @currency.valid?
  end

  test 'should be invalid nimi' do
    @currency.nimi = 'TOO_LONG'
    refute @currency.valid?

    # Too short nimi
    @currency.nimi = 'S'
    refute @currency.valid?

    @currency.nimi = nil
    refute @currency.valid?
  end

  test 'nimi should be unique per company' do
    @currency.nimi = 'BIT'
    refute @currency.save
  end

  test 'nimi should be uppercased' do
    @currency.nimi = 'tes'
    assert @currency.save
    assert_equal @currency.nimi, 'TES'
  end

end
