require 'test_helper'

class PackageTest < ActiveSupport::TestCase
  fixtures %w(packages keywords package_codes)

  setup do
    @package = packages(:steel_barrel)
  end

  test "assert fixtures are valid" do
    assert @package.valid?
  end

  test "relations" do
    assert_equal 1, @package.translations.count
    assert_equal 1, @package.package_codes.count
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

  test 'associations are destroyed when package is destroyed' do
    assert_difference     'Package.count',                     -1 do
      assert_difference   'Keyword::PackageTranslation.count', -1 do
        assert_difference 'PackageCode.count',                 -1 do
          @package.destroy
        end
      end
    end
  end
end
