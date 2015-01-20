require 'test_helper'

class FixedAssets::CommodityTest < ActiveSupport::TestCase
  setup do
    @commodity = fixed_assets_commodities(:commodity_one)
  end

  test 'fixtures are valid' do
    assert @commodity.valid?
    assert_equal "Acme Corporation", @commodity.company.nimi
  end

  test 'model relations' do
    assert_not_nil @commodity.voucher
  end

  test 'should update lock' do
    @commodity.lock_all_rows

    assert_equal 'X', @commodity.voucher.rows.first.lukko
    assert_equal true, @commodity.rows.first.locked
  end
end
