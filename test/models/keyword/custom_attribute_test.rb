require 'test_helper'

class Keyword::CustomAttributeTest < ActiveSupport::TestCase
  setup do
    @attrib = keywords(:mysql_alias_1)
  end

  test 'fixtures are valid' do
    assert @attrib.valid?
  end
end
