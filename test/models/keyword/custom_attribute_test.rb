require 'test_helper'

class Keyword::CustomAttributeTest < ActiveSupport::TestCase
  fixtures %w(keywords)

  setup do
    @attrib = keywords(:mysql_alias_1)
  end

  test 'fixtures are valid' do
    assert @attrib.valid?
  end

  test 'keyword attribute aliases' do
    @attrib.database_field = 'foo.bar'
    @attrib.label          = 'Foobar'
    @attrib.set_name       = 'BAZ'
    @attrib.default_value  = 'Wheee!'
    @attrib.help_text      = 'This is helpful'
    @attrib.required       = :optional
    @attrib.visibility     = :hidden
    @attrib.save!

    assert @attrib.reload.optional?
    assert @attrib.hidden?
    assert_equal 'foo.bar',         @attrib.database_field
    assert_equal 'Foobar',          @attrib.label
    assert_equal 'BAZ',             @attrib.set_name
    assert_equal 'Wheee!',          @attrib.default_value
    assert_equal 'This is helpful', @attrib.help_text
  end

  test 'unique scope' do
    attrib = @attrib.dup
    refute attrib.valid?

    attrib.database_field = 'different.field'
    assert attrib.valid?

    attrib.database_field = @attrib.database_field
    refute attrib.valid?

    attrib.set_name = 'different_set'
    assert attrib.valid?
  end

  test 'field and table name' do
    @attrib.database_field = 'foo.bar'
    assert_equal "bar", @attrib.field
    assert_equal "foo", @attrib.table

    @attrib.database_field = 'foo.bar.baz'
    assert_equal "baz", @attrib.field
    assert_equal "foo", @attrib.table
  end

  test 'fetch set' do
    params = {
      table_name: 'asiakas',
      set_name: 'PROSPEKTI'
    }

    assert_equal 1, Keyword::CustomAttribute.fetch_set(params).count
  end
end
