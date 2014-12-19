require 'test_helper'

class Accounting::FixedAssets::RowTest < ActiveSupport::TestCase

  def setup
    # Valid Accounting fixed assets commodity row
    @fixed_asset_row = accounting_fixed_assets_rows(:one)

    @account = accounting_accounts(:one)
    @fixed_asset_row.tilino = @account.tilino

    # New object
    @new_one = Accounting::FixedAssets::Row.new
  end

  test 'fixture should be valid' do
    assert_equal @new_one.class, @fixed_asset_row.class
    assert @fixed_asset_row.valid?
  end

end
