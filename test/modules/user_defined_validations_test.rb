require 'test_helper'

# Create dummy class for testing UserDefinedValidations concern using asiakas -table
class UserDefinedValidationsDummyClass < BaseModel
  include UserDefinedValidations

  self.table_name = :asiakas
end

class UserDefinedValidationsTest < ActiveSupport::TestCase
  fixtures %w(keywords customers)

  setup do
    @attribute = keywords(:mysql_alias_1)
    @customer = UserDefinedValidationsDummyClass.create!(
      nimi: 'Nimitys',
      luontiaika: Time.now,
      muutospvm: Time.now
    )
  end

  test 'should change validations' do
    @customer.table_set_name = :prospekti

    @attribute.database_field = 'asiakas.osoite'
    @attribute.required = :optional
    @attribute.save!

    @customer.osoite = ''
    assert @customer.valid?

    @attribute.required = :mandatory
    @attribute.save!

    refute @customer.valid?
  end
end
