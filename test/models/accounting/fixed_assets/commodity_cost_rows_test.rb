require 'test_helper'

class Accounting::FixedAssets::CommodityCostRowTest < ActiveSupport::TestCase

  def setup
    @costrow = accounting_fixed_assets_commodity_cost_rows(:one_cost_row)
    @commodity = accounting_fixed_assets_commodities(:one_commodity_row)
  end

  test 'fixtures should be valid' do
    assert @costrow.valid?
    assert_equal 2, @commodity.cost_rows.count
  end

  test 'duplicate accounting row links not allowed for single commodity' do
    costrow2 = accounting_fixed_assets_commodity_cost_rows(:two_cost_row)
    costrow2.tiliointirivi_tunnus = @costrow.tiliointirivi_tunnus
    refute costrow2.valid?
  end
end
