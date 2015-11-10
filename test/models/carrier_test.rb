require 'test_helper'

class CarrierTest < ActiveSupport::TestCase
  fixtures %w(carriers package_codes)

  setup do
    @carrier = carriers(:hit)
  end

  test 'all fixtures should be valid' do
    assert @carrier.valid?, @carrier.errors.full_messages.inspect
  end

  test 'relations' do
    assert_equal 1, @carrier.package_codes.count
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
    @carrier.update_attribute(:neutraali, :neutral)
    assert @carrier.reload.neutral?
    refute @carrier.not_neutral?

    @carrier.update_attribute(:neutraali, :not_neutral)
    refute @carrier.reload.neutral?
    assert @carrier.not_neutral?
  end
end
