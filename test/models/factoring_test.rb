require 'test_helper'

class FactoringTest < ActiveSupport::TestCase
  fixtures %w(
    factorings
    terms_of_payments
  )

  setup do
    @nordea = factorings :nordea
    @sampo = factorings :sampo
  end

  test 'fixtures should be valid' do
    assert @nordea.valid?
    assert @sampo.valid?
  end

  test 'relations' do
    assert_equal 'Nordea rahoitus', @nordea.terms_of_payments.first.teksti
  end
end
