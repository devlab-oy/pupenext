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
    assert_not_nil @commodity.voucher, "hyödykkeellä on tosite, jolle kirjtaaan SUMU-poistot"
    assert_not_nil @commodity.voucher.rows, "em. tosittella on SUMU-poisto rivejä"
    assert_not_nil @commodity.commodity_rows, "hyödyllällä on rivejä, jolla kirjtaan EVL poistot"
    assert_not_nil @commodity.procurement_rows, "hyödyllällä on tiliöintirivejä, joilla on valittu hyödykkeelle kuuluvat hankinnat"
  end

  test 'should update lock' do
    @commodity.lock_rows

    assert_equal 'X', @commodity.voucher.rows.first.lukko
    assert_equal true, @commodity.commodity_rows.first.locked
  end

  test 'should calculate SUMU depreciation with fixed_by_percentage' do
    amount = 1000
    fiscal_year = @commodity.company.get_months_in_current_fiscal_year
    result = @commodity.divide_to_payments(amount, fiscal_year*2)

    assert_equal fiscal_year, 6
    assert_equal amount/2, result.sum

    firsti = 83.33.to_d
    lasti = 83.35.to_d

    assert_equal fiscal_year, result.count
    assert_equal firsti, result.first
    assert_equal lasti, result.last
  end

  test 'should calculate SUMU depreciation with degressive_by_percentage' do
    # Full amount to be reducted
    reduct = 10000
    fiscal_year = @commodity.company.get_months_in_current_fiscal_year
    # Yearly degressive percentage
    fiscalyearly_percentage = 35

    result = @commodity.degressive_by_percentage(reduct, fiscalyearly_percentage)
    assert_equal fiscal_year, result.count
    assert_equal 3500, result.sum

    result = @commodity.degressive_by_percentage(reduct, fiscalyearly_percentage, 3500)
    assert_equal fiscal_year, result.count
    assert_equal 2275, result.sum
  end

  test 'should calculate SUMU depreciation with fixed_by_month' do
    # Full amount to be reducted
    total_amount = 10000
    # Total amounts of depreciations
    total_depreciations = 12

    fiscal_year = @commodity.company.get_months_in_current_fiscal_year

    result = @commodity.fixed_by_month(total_amount, total_depreciations, 6, 5000)

    assert_equal fiscal_year, result.count
    assert_equal 5000, result.sum
  end

  test 'should calculate EVL depreciation with fixed_by_percentage' do

  end

  test 'should calculate EVL depreciation with degressive_by_percentage' do

  end

  test 'should calculate EVL depreciation with fixed_by_month' do

  end

  test 'should create bookkeeping voucher and rows for type T and P' do
    params = {
      name: 'Chair50000',
      description: 'Chair for CEO',
      amount: 10000.0,
      planned_depreciation_type: 'T',
      planned_depreciation_amount: 12,
      btl_depreciation_type: 'P',
      btl_depreciation_amount: 45,
      activated_at: @commodity.company.get_fiscal_year.first.to_date,
      purchased_at: Time.now,
      status: 'A'
    }

    @commodity.voucher = nil
    @commodity.attributes = params
    @commodity.save

    assert_difference('FixedAssets::CommodityRow.count', 6) do
      assert_difference('Head::VoucherRow.count', 6) do
        @commodity.generate_rows
      end
    end

    assert_equal @commodity.voucher.rows.first.summa, 833.33
    assert_equal @commodity.voucher.rows.last.summa, 833.35

    totali = BigDecimal.new 0
    @commodity.voucher.rows.each { |x| totali += x.summa }
    assert_equal totali, 5000
  end

  test 'should create bookkeeping rows for type B' do
    params = {
      name: 'Chair50000',
      description: 'Chair for CEO',
      amount: 10000.0,
      planned_depreciation_type: 'B',
      planned_depreciation_amount: 12,
      btl_depreciation_type: 'P',
      btl_depreciation_amount: 45,
      activated_at: @commodity.company.get_fiscal_year.first.to_date,
      purchased_at: Time.now,
      status: 'A'
    }

    @commodity.voucher = nil
    @commodity.attributes = params
    @commodity.save

    assert_difference('Head::VoucherRow.count', 6) do
      @commodity.generate_rows
    end

    assert_equal @commodity.voucher.rows.first.summa, 200
    assert_equal @commodity.voucher.rows.last.summa, 240

    totali = BigDecimal.new 0
    @commodity.voucher.rows.each { |x| totali += x.summa }
    assert_equal totali, 1200
  end

  test 'should get options for depreciation types' do
    assert_equal 4, @commodity.get_options_for_type.count
    returned_types = []
    @commodity.get_options_for_type.each { |x| returned_types.push x.last }

    all_types = [ 'T','P','B','' ]
    all_types.each do |typ|
      assert returned_types.include? typ
    end

  end

  test 'should get options for commodity statuses' do
    assert_equal 3, @commodity.get_options_for_status.count
    returned_options = []
    @commodity.get_options_for_status.each { |x| returned_options.push x.last }

    all_statuses = [ 'A','P','' ]
    all_statuses.each do |stat|
      assert returned_options.include? stat
    end
  end
end
