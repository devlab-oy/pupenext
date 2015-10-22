require 'test_helper'

class ContactPersonTest < ActiveSupport::TestCase
  fixtures %w(
    contact_persons
  )

  setup do
    @pirkko = contact_persons(:pirkko)
  end

  test 'model relations' do
    assert_equal "Pirkko", @pirkko.nimi
  end

end
