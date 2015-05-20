require 'test_helper'

class FixedAssets::CommodityRowTest < ActiveSupport::TestCase
  fixtures %w(fixed_assets/commodities fixed_assets/commodity_rows heads head/voucher_rows)

  setup do
    @one = fixed_assets_commodity_rows(:one)
    @two = fixed_assets_commodity_rows(:two)
  end

  test 'fixtures are valid' do
    assert @one.valid?, @one.errors.full_messages
    assert_equal "Acme Corporation", @one.commodity.company.nimi
    assert @two.valid?, @two.errors.full_messages
    assert_equal "This is a commodity!", @two.commodity.name
  end

  test 'must happen in current active fiscal period' do
    params = {
      tilikausi_alku: '2015-01-01',
      tilikausi_loppu: '2015-06-30'
    }
    @one.commodity.company.update_attributes! params

    @one.transacted_at = '2017-31-1'
    refute @one.valid?, @one.errors.full_messages
  end

  test 'has a depreciation difference' do
    testrow = head_voucher_rows(:one)
    testrow.tilino = '4444'
    testrow.save

    assert_equal 233, @one.depreciation_difference
    assert_equal 1234, @two.depreciation_difference
  end
end
