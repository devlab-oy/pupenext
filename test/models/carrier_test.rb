require 'test_helper'

class CarrierTest < ActiveSupport::TestCase
  def setup
    @carrier = carrier(:hit)
  end

  test 'all fixtures should be valid' do
    assert @carrier.valid?, @carrier.errors.full_messages.inspect
  end

  test 'cannot be empty' do
    assert @carrier.nimi.present?
    assert @carrier.koodi.present?
  end

  test 'should be numerical' do
    @carrier.pakkauksen_sarman_minimimitta = 1.0
    assert_equal 1, @carrier.pakkauksen_sarman_minimimitta.to_i

    @carrier.pakkauksen_sarman_minimimitta = "k"
    assert_equal 0, @carrier.pakkauksen_sarman_minimimitta.to_i
  end

  test 'should be neutral' do
    assert_equal false, Carrier.new.neutraali

    @carrier.update_attribute(:neutraali, true)
    assert_equal true, @carrier.reload.neutraali

    @carrier.update_attribute(:neutraali, false)
    assert_equal false, @carrier.reload.neutraali
  end
end
