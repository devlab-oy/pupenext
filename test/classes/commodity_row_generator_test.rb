require 'test_helper'

class CommodityRowGeneratorTest < ActiveSupport::TestCase

  setup do
    @commodity = fixed_assets_commodities(:commodity_one)
    @generator = CommodityRowGenerator.new(commodity_id: @commodity.id)
  end

  test 'fixture is correct for calculations' do
    # We have a 12 month fiscal year
    fiscal_year = @commodity.company.months_in_current_fiscal_year
    assert_equal fiscal_year, 12

    # We activate July 1st, current year.
    activated_at = Date.today.change(month: 7, day: 1)
    assert_equal activated_at, @commodity.activated_at
  end

  test 'should calculate with fixed by percentage' do
    # Tasapoisto vuosiprosentti
    full_amount = 10000
    percentage = 35
    result = @generator.fixed_by_percentage(full_amount, percentage)

    assert_equal result.sum, full_amount * percentage / 100
    assert_equal result.first, 833.33
    assert_equal result.second, 833.33
    assert_equal result.last, 166.68
  end

  test 'should calculate with degressive by percentage' do
    # Menojäännöspoisto vuosiprosentti
    # Full amount to be reducted
    reduct = 10000

    # Yearly degressive percentage
    fiscalyearly_percentage = 35

    result = @generator.degressive_by_percentage(reduct, fiscalyearly_percentage)
    assert_equal 6, result.count
    assert_equal 3500, result.sum

    result = @generator.degressive_by_percentage(reduct, fiscalyearly_percentage, 3500)
    assert_equal 6, result.count
    assert_equal 2275, result.sum
  end

  test 'should calculate with fixed by month' do
    # Tasapoisto kuukausittain
    # Full amount to be reducted
    total_amount = 10000
    # Total amounts of depreciations
    total_depreciations = 12

    result = @generator.fixed_by_month(total_amount, total_depreciations, 6, 5000)

    assert_equal 6, result.count
    assert_equal 5000, result.sum
  end
end
