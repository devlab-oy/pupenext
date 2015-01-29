require 'test_helper'

class FixedAssets::CommodityRowTest < ActiveSupport::TestCase
  setup do
    @one = fixed_assets_commodity_rows(:one)
    @two = fixed_assets_commodity_rows(:two)
  end

  test 'fixtures are valid' do
    assert @one.valid?
    assert_equal "Acme Corporation", @one.commodity.company.nimi
    assert @two.valid?
    assert_equal "This is a commodity!", @two.commodity.name
  end
end
