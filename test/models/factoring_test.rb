require 'test_helper'

class FactoringsTest < ActiveSupport::TestCase
  fixtures %w(
    factorings
    terms_of_payments
    )

  setup do
    @top = terms_of_payments(:sixty_days_net)
    @top.factoring = "sampo"
    @top.save

    @fac = factorings(:sampo)
  end

  test "make sure relations are correct" do
    assert_not_equal 0, @fac.terms_of_payments.count
  end
end
