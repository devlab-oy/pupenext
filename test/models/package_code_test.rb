require 'test_helper'

class PackageCodeTest < ActiveSupport::TestCase
  fixtures %w(package_codes carriers packages)

  setup do
    @code = package_codes(:code_aa)
  end

  test 'fixtures are valid' do
    assert @code.valid?
  end

  test 'relations' do
    assert_equal Package, @code.package.class
    assert_equal Carrier, @code.carrier.class
  end
end
