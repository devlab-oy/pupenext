require 'test_helper'

class CurrencyTest < ActiveSupport::TestCase
  fixtures %w(currencies)

  setup do
    @currency = currencies(:eur)
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

  test 'should search by like' do
    params = {
      kurssi: 1
    }

    assert_equal 2, Currency.search_like(params).count

    params = {
      kurssi: 1,
      nimi: 'E'
    }

    assert_equal 1, Currency.search_like(params).count
  end

  test 'should search exact match' do
    params = {
      nimi: '@EUR'
    }

    assert_equal 1, Currency.search_like(params).count
  end

  test 'should not search by like' do
    params = {
      foobar: 1
    }

    assert_raises(ActiveRecord::StatementInvalid) { Currency.search_like(params).count }
  end

  test 'should sanitize comma' do
    @currency.kurssi = "3,5"

    assert_equal 3.5, @currency.kurssi
  end
end
