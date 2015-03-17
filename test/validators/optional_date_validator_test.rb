require 'test_helper'

# Create dummy class for testing OptionalDateValidator using yhtio -table
class DummyClass < ActiveRecord::Base
  self.table_name = :yhtio
  validates :tilikausi_alku, optional_date: true
end

class OptionalDateValidatorTest < ActiveSupport::TestCase
  setup do
    params = { yhtio: 'dummy', muuttaja: 'dummy', laatija: 'dummy' }
    @dummy = DummyClass.new params
  end

  test 'should be valid date' do
    # empty instance should be valid
    assert @dummy.valid?, @dummy.errors.full_messages

    @dummy.tilikausi_alku = '0001-01-01'
    assert @dummy.valid?

    @dummy.tilikausi_alku = nil
    assert @dummy.valid?

    @dummy.tilikausi_alku = ''
    refute @dummy.valid?

    @dummy.tilikausi_alku = '2015-35-35'
    refute @dummy.valid?

    @dummy.tilikausi_alku = '0000-00-00'
    refute @dummy.valid?
  end
end
