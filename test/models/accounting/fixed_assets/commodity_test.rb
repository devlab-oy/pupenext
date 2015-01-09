require 'test_helper'

class Accounting::FixedAssets::CommodityTest < ActiveSupport::TestCase

  def setup
    # Valid Accounting fixed assets commodity
    @commodity = accounting_fixed_assets_commodities(:one_commodity_row)
    @account = accounting_accounts(:one_account_row)

    @commodity.tilino = @account.tilino
    # New object
    @new_commodity = Accounting::FixedAssets::Commodity.new
  end

  test 'fixture should be valid' do
    assert_equal @new_commodity.class, @commodity.class
    assert @commodity.valid?, "#{@commodity.errors.full_messages} #{@commodity.cost_rows.inspect}"
  end

  test 'should calculate payments' do

    amount = 1000
    months = 11
    result = @commodity.divide_to_payments(amount, months)

    assert_equal amount, result.sum
    assert_equal months, result.count
    assert_equal 90.91, result.first
    assert_equal 90.9.to_d, result.last

    # Create two random parameters
    randomizer = [Random.rand(0...100000), Random.rand(1...12*5)]
    result = @commodity.divide_to_payments(randomizer[0], randomizer[1])

    assert_equal randomizer[0], result.sum
    assert_equal randomizer[1], result.count
  end

  test 'should calculate degressive payments by percentage' do

    amount = 10000
    percentage = 45
    result = @commodity.divide_to_degressive_payments_by_percentage(amount,percentage)
    assert_equal amount, result.sum
    assert_equal 36, result.count
    assert_equal 375, result.first
    assert_equal 2634, result.last

    # Create two random parameters
    randomizer = [Random.rand(0...100000), Random.rand(10...60)]
    result = @commodity.divide_to_degressive_payments_by_percentage(randomizer[0], randomizer[1])

    assert_equal randomizer[0], result.sum
  end

  test 'should calculate degressive payments by months' do

    amount = 60000
    months = 35
    result = @commodity.divide_to_degressive_payments_by_months(amount, months)
    assert_equal amount, result.sum
    assert_equal months, result.count
    assert_equal '1714.29', result.first.to_s
    assert_equal '2355.46', result.last.to_s

    # Create two random parameters
    randomizer = [Random.rand(0...100000), Random.rand(12...5*12)]
    result = @commodity.divide_to_degressive_payments_by_months(randomizer[0], randomizer[1])

    assert_equal randomizer[0], result.sum
    assert_equal randomizer[1], result.count
  end

  test 'should update lock' do
    @commodity = accounting_fixed_assets_commodities(:two_commodity_row)
    @commodity.lock_all_rows

    assert_equal 'X', @commodity.accounting_voucher.rows.first.lukko
    assert_equal 'X', @commodity.rows.first.lukko
  end
end
