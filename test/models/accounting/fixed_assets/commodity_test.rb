require 'test_helper'

class Accounting::FixedAssets::CommodityTest < ActiveSupport::TestCase

  def setup
    # Valid Accounting fixed assets commodity
    @commodity = accounting_fixed_assets_commodities(:one_commodity_row)
#    @account = accounting_accounts(:one_account_row)
#    @commodity.tilino = @account.tilino
    # New object
    @new_commodity = Accounting::FixedAssets::Commodity.new
  end

  test 'fixture should be valid' do
    assert_equal @new_commodity.class, @commodity.class
    assert @commodity.valid?, "#{@commodity.errors.full_messages} #{@commodity.cost_rows.inspect}"
  end

  # test 'should calculate degressive payments by percentage' do

  #   amount = 10000
  #   percentage = 45
  #   result = @commodity.divide_to_degressive_payments_by_percentage(amount,percentage)
  #   assert_equal amount, result.sum
  #   assert_equal 36, result.count
  #   assert_equal 375, result.first
  #   assert_equal 2634, result.last

  #   # Create two random parameters
  #   randomizer = [Random.rand(0...100000), Random.rand(10...60)]
  #   result = @commodity.divide_to_degressive_payments_by_percentage(randomizer[0], randomizer[1])

  #   assert_equal randomizer[0], result.sum
  # end

  test 'should update lock' do
    @commodity = accounting_fixed_assets_commodities(:two_commodity_row)
    @commodity.lock_all_rows

    assert_equal 'X', @commodity.accounting_voucher.rows.first.lukko
    assert_equal 'X', @commodity.rows.first.lukko
  end

  test 'account number should match between all records' do
    @commodity = accounting_fixed_assets_commodities(:two_commodity_row)
    assert_equal @commodity.rows.first.tilino, @commodity.tilino
    assert_equal @commodity.rows.last.tilino, @commodity.tilino
    assert @commodity.valid?

    @commodity.tilino = 1234

    assert_not_equal @commodity.rows.first.tilino, @commodity.tilino
    refute @commodity.valid?, 'Should not be valid'
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
    @commodity = accounting_fixed_assets_commodities(:one_commodity_row)
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
    @commodity = accounting_fixed_assets_commodities(:one_commodity_row)
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
