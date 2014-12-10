require 'test_helper'

class Accounting::FixedAssets::CommodityTest < ActiveSupport::TestCase

  def setup
    # Valid Accounting fixed assets commodity
    @commodity = accounting_fixed_assets_commodities(:one)

    # New object
    @new_commodity = Accounting::FixedAssets::Commodity.new
  end

  test 'fixture should be valid' do
    assert_equal @new_commodity.class, @commodity.class
    assert @commodity.valid?
  end

  test 'should calculate payments' do
    # Create two random parameters
    randomizer = [Random.rand(0...100000), Random.rand(1...12*5)]
    result = @commodity.divide_to_payments(randomizer[0], randomizer[1])

    assert_equal randomizer[0], result.sum
    assert_equal randomizer[1], result.count
  end

  test 'should calculate degressive payments by percentage' do
    # Create two random parameters
    randomizer = [60000, 35]
    randomizer = [Random.rand(0...100000), Random.rand(10...60)]
    result = @commodity.divide_to_degressive_payments_by_percentage(randomizer[0], randomizer[1])

    assert_equal randomizer[0], result.sum
  end

end
