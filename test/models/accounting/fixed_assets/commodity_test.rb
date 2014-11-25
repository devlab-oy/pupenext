require 'test_helper'

class Accounting::FixedAssets::CommodityTest < ActiveSupport::TestCase

  def setup
    # Valid Accounting fixed assets commodity row
    @commodity = accounting_fixed_assets_commodities(:one)

    # New object
    @new_commodity = Accounting::FixedAssets::Commodity.new
  end

  test 'fixture should be valid' do
    assert_equal @new_commodity.class, @commodity.class
    assert @commodity.valid?
  end

end
