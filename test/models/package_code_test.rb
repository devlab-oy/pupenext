require 'test_helper'

class PackageCodeTest < ActiveSupport::TestCase
  setup do
    @code = package_codes(:code_aa)
  end

  test 'fixtures are valid' do
    assert @code.valid?
  end

  test 'relations' do
    assert_equal Package, @code.package.class
  end
end
