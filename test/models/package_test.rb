require 'test_helper'

class PackageTest < ActiveSupport::TestCase

  def setup
    @package = packages(:first)
  end

  test "assert fixtures are valid" do
    assert @package.valid?
  end

  test "pakkaus cant be empty" do
    @package.pakkaus = ''
    refute @package.valid?
  end

  test "pakkauskuvaus cant be empty" do
    @package.pakkauskuvaus = ''
    refute @package.valid?
  end

  test "dimensions check if parameter is triggered" do
    @package.company.parameter.update_attribute :varastopaikkojen_maarittely, ''

    @package.leveys = 0
    @package.korkeus = 0
    @package.syvyys = 0
    @package.paino = 0
    assert @package.valid?

    @package.company.parameter.update_attribute :varastopaikkojen_maarittely, :M
    refute @package.valid?

    @package.leveys = 10
    @package.korkeus = 10
    @package.syvyys = 10
    @package.paino = 10
    assert @package.valid?
  end

  test "kayttoprosentti set to 100" do
    @package.kayttoprosentti = 0
    refute @package.valid?

    @package.kayttoprosentti = 1
    assert @package.valid?

    @package.kayttoprosentti = 101
    refute @package.valid?

    @package.kayttoprosentti = 100
    assert @package.valid?

    assert_equal 100, Package.new.kayttoprosentti
  end
end
