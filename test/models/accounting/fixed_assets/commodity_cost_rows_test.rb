require 'test_helper'

class Accounting::FixedAssets::CommodityCostRowTest < ActiveSupport::TestCase

  def setup
    @costrow = accounting_fixed_assets_commodity_cost_rows(:one)
  end

  test 'fixtures should be valid' do
    assert @costrow.valid?, "#{@costrow.errors.full_messages}"
  end
end
