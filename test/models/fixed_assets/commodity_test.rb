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

    fiscal_year = @commodity.company.get_months_in_current_fiscal_year

    result = @commodity.degressive_by_fiscal_payments(total_amount, total_depreciations, 6, 5000)

    assert_equal fiscal_year, result.count
    assert_equal 5000, result.sum
  end

  test 'should create bookkeeping voucher and rows' do
    params = {
      name: 'Chair50000',
      description: 'Chair for CEO',
      amount: 10000.0,
      planned_depreciation_type: 'T',
      planned_depreciation_amount: 12,
      btl_depreciation_type: 'P',
      btl_depreciation_amount: 45,
      activated_at: Time.now,
      purchased_at: Time.now,
      status: 'A'
    }
    @commodity.voucher = nil
    @commodity.attributes = params

    assert_difference('FixedAssets::CommodityRow.count', 5) do
      assert_difference('Head::VoucherRow.count', 5) do
        @commodity.generate_rows = true
        @commodity.save
      end
    end
  end

  test 'should get options for depreciation types' do
    assert_equal 5, @commodity.get_options_for_type.count
    returned_types = []
    @commodity.get_options_for_type.each { |x| returned_types.push x.last }

    all_types = [ 'T','P','D','B','' ]
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
