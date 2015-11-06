require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  fixtures %w(
    delivery_methods
    locations
  )

  setup do
    @tokyo = locations :tokyo
  end

  test 'fixtures are valid' do
    assert @tokyo.valid?
  end

  test 'relations' do
    assert_equal 'Acme Corporation', @tokyo.company.nimi
  end
end
