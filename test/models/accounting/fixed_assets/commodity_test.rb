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

  test 'should calculate depreciations with fixed monthly amount' do
    @commodity.kayttoonottopvm = Time.now
    params = {
      type: 'T',
      full_cost: 12000,
      yearly_reduction: 12,
      cost_remaining: 12000,
      results: []
    }
    yearfromnow = Time.now.advance(:years => +1)

    result = @commodity.calculate_all_depreciations(params)

    assert_equal 12, result.count
    assert_equal 1000, result.first[:monthly_depreciation]
    assert_equal Time.now.to_date, result.first[:tapvm].to_date
    assert_equal yearfromnow.to_date, result.last[:tapvm].to_date
  end

  test 'should calculate depreciations with fixed yearly percentage amount' do
    @commodity.summa = 10000
    @commodity.sumu_poistotyyppi = 'P'
    @commodity.sumu_poistoera = 20

    params = {
      type: nil,
      full_cost: nil,
      yearly_reduction: kuk,
      cost_remaining: kok,
      results: []
    }
    result = @commodity.calculate_all_depreciations(params)

    assert_equal result, 'kissa'
    assert_equal 12, result.count
    #assert_equal 1000, result.first[:reduction]
  end

end
