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
    assert_equal true, @commodity.commodity_rows.first.locked
  end

  test 'should calculate payments by fiscal year' do
    amount = 1000
    fiscal_year = @commodity.company.get_months_in_current_fiscal_year
    result = @commodity.divide_to_payments(amount, fiscal_year)

    assert_equal amount, result.sum
    assert_equal fiscal_year, result.count
    assert_equal 166.67, result.first
    assert_equal 166.65, result.last
  end

  test 'should calculate degressive payments by fiscal year' do
    # Amount to be reducted during this fiscal year
    reduct = 1000
    fiscal_year = @commodity.company.get_months_in_current_fiscal_year

    result = @commodity.divide_to_degressive_payments_by_months(reduct, fiscal_year)

    assert_equal result.sum, reduct
    assert_equal result.count, fiscal_year
  end

  test 'should calculate depreciations by fiscal percentage' do
    # Full amount to be reducted
    reduct = 10000
    fiscal_year = @commodity.company.get_months_in_current_fiscal_year
    # Yearly degressive percentage
    fiscalyearly_percentage = 35

    result = @commodity.degressive_by_fiscal_percentage(reduct, fiscalyearly_percentage)

    assert_equal fiscal_year, result.count
    assert_equal 3500, result.sum

    result = @commodity.degressive_by_fiscal_percentage(reduct, fiscalyearly_percentage, 3500)
    assert_equal fiscal_year, result.count
    assert_equal 2275, result.sum
  end

  test 'should calculate depreciations by fiscal payments' do
    # Full amount to be reducted
    total_amount = 10000
    # Total amounts of depreciations
    total_depreciations = 12
    # How many depreciations have been done
    past_fiscal_depreciations = 0

    fiscal_year = @commodity.company.get_months_in_current_fiscal_year

    result = @commodity.degressive_by_fiscal_payments(total_amount, total_depreciations, 6, 5000)

    assert_equal fiscal_year, result.count
    assert_equal 5000, result.sum

    #resse = @commodity.divide_to_payments(10000, 12)
    #assert_equal resse.sum.to_s, 'kissa'
  end
end
