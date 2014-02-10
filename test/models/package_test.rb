require 'test_helper'

class PackageTest < ActiveSupport::TestCase

  def setup
    @p = packages(:first)
  end

  test "assert fixtures are valid" do
    assert @p.valid?
  end

  test "pakkaus cant be empty" do
    @p.pakkaus = ''
    refute @p.valid?
  end

  test "pakkauskuvaus cant be empty" do
    @p.pakkauskuvaus = ''
    refute @p.valid?
  end

end
