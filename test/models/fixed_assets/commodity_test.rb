require 'test_helper'

class FixedAssets::CommodityTest < ActiveSupport::TestCase
  setup do
    @commodity = fixed_assets_commodities(:commodity_one)
    @options_for_type = FixedAssets::Commodity.options_for_type
    @options_for_status = FixedAssets::Commodity.options_for_status
  end

  test 'fixtures are valid' do
    assert @commodity.valid?, @commodity.errors.full_messages
    assert_equal "Acme Corporation", @commodity.company.nimi
  end

  test 'model relations' do
    assert_not_nil @commodity.voucher, "hyödykkeellä on tosite, jolle kirjtaaan SUMU-poistot"
    assert_not_nil @commodity.voucher.rows, "em. tosittella on SUMU-poisto rivejä"
    assert_not_nil @commodity.commodity_rows, "hyödyllällä on rivejä, jolla kirjtaan EVL poistot"
    assert_not_nil @commodity.procurement_rows, "hyödyllällä on tiliöintirivejä, joilla on valittu hyödykkeelle kuuluvat hankinnat"
  end

  test 'amount should be set to sum of procurement_rows' do
    assert_equal @commodity.amount, @commodity.procurement_rows.sum(:summa)

    proc_row = @commodity.procurement_rows.first
    proc_row.summa += 100
    proc_row.save!
    assert_not_equal @commodity.amount, @commodity.procurement_rows.sum(:summa)

    assert @commodity.save
    assert_equal @commodity.amount, @commodity.procurement_rows.sum(:summa)
  end

  test 'required fields when active' do
    @commodity.status = ''
    @commodity.planned_depreciation_type = ''
    @commodity.planned_depreciation_amount = ''
    @commodity.btl_depreciation_type = ''
    @commodity.btl_depreciation_amount = ''
    @commodity.amount = ''
    @commodity.activated_at = ''

    assert @commodity.valid?, @commodity.errors.full_messages

    @commodity.status = 'A'
    refute @commodity.valid?, "should not be valid"
  end

  test 'cannot set active unless we have procurement rows' do
    assert_not_equal 0, @commodity.procurement_rows.count
    @commodity.status = 'A'
    assert @commodity.valid?

    @commodity.procurement_rows.delete_all
    @commodity.status = 'A'
    refute @commodity.valid?, 'should not be valid'
  end

  test 'must activate on open fiscal year' do
    params = {
      tilikausi_alku: '2015-01-01',
      tilikausi_loppu: '2015-03-31'
    }
    @commodity.company.attributes = params

    @commodity.activated_at = '2015-01-01'
    @commodity.status = 'A'
    assert @commodity.valid?, @commodity.errors.full_messages

    @commodity.activated_at = '2015-06-01'
    refute @commodity.valid?, 'should not be valid'
  end

  test 'amount is a percentage' do
    [100.01, 101].each do |p|
      @commodity.planned_depreciation_amount = p
      @commodity.planned_depreciation_type = 'T'
      assert @commodity.valid?

      @commodity.planned_depreciation_type = 'P'
      refute @commodity.valid?

      @commodity.planned_depreciation_type = 'B'
      refute @commodity.valid?
    end
  end

  test 'should get options for depreciation types' do
    assert_equal 4, @options_for_type.count

    returned_types = @options_for_type.map(&:last).sort
    all_types = [ '', 'B', 'P', 'T' ]

    assert_equal all_types, returned_types
  end

  test 'should get options for commodity statuses' do
    assert_equal 3, @options_for_status.count

    returned_options = @options_for_status.map(&:last).sort
    all_statuses = [ '', 'A', 'P' ]

    assert_equal all_statuses, returned_options
  end

  test 'procurement row methods work' do
    @commodity.procurement_rows.delete_all
    params = {
      tilino: '4443',
      kustp: 13,
      projekti: 33,
      kohde: 43
    }
    @commodity.procurement_rows.build params

    assert_equal params[:tilino], @commodity.fixed_assets_account
    assert_equal params[:kustp], @commodity.procurement_cost_centres.first
    assert_equal params[:projekti], @commodity.procurement_projects.first
    assert_equal params[:kohde], @commodity.procurement_targets.first

    @commodity.procurement_rows.delete_all
    assert_nil @commodity.fixed_assets_account
    assert_empty @commodity.procurement_cost_centres
    assert_empty @commodity.procurement_projects
    assert_empty @commodity.procurement_targets
  end

  test 'linkable invoices method works' do
    assert_equal 1, @commodity.linkable_invoices.count
    @commodity.procurement_rows.delete_all
    assert_equal 2, @commodity.linkable_invoices.count
  end

  test 'linkable vouchers method works' do
    assert_equal 1, @commodity.linkable_vouchers.count
    @commodity.procurement_rows.delete_all
    assert_equal 1, @commodity.linkable_vouchers.count
  end

  test 'current bookkeeping value works' do
    @commodity.status = 'A'
    @commodity.save!

    CommodityRowGenerator.new(commodity_id: @commodity.id, user_id: users(:bob).id).generate_rows

    assert_equal 8235.28.to_d, @commodity.bookkeeping_value('2015-09-30'.to_date)
    assert_equal 6500, @commodity.bookkeeping_value

    # Sold commodity bkvalue is 0
    salesparams = {
      amount_sold: @commodity.amount,
      deactivated_at: Date.today,
      profit_account: accounts(:account_100),
      depreciation_remainder_handling: 'S',
    }
    @commodity.attributes = salesparams
    @commodity.save!

    CommodityRowGenerator.new(commodity_id: @commodity.id, user_id: users(:bob).id).sell
    @commodity.reload

    assert_equal 'P', @commodity.status
    assert_equal 0, @commodity.bookkeeping_value
  end

  test 'cant be sold with invalid params' do
    validparams = {
      amount_sold: 9800,
      deactivated_at: Date.today,
      profit_account: '100',
      depreciation_remainder_handling: 'S'
    }
    # Invalid status
    @commodity.status = ''
    refute @commodity.can_be_sold?(validparams)

    # Invalid profit account
    invalidparams = {
      amount_sold: 9800,
      deactivated_at: Date.today,
      profit_account: '0',
      depreciation_remainder_handling: 'S'
    }
    @commodity.status = 'A'
    refute @commodity.can_be_sold?(invalidparams)

    # Invalid depreciation handling
    invalidparams = {
      amount_sold: 9800,
      deactivated_at: Date.today,
      profit_account: accounts(:account_100).tilino,
      depreciation_remainder_handling: 'K'
    }
    refute @commodity.can_be_sold?(invalidparams)

    # Invalid sales date
    invalidparams = {
      amount_sold: 9800,
      deactivated_at: @commodity.company.current_fiscal_year.first - 1,
      profit_account: accounts(:account_100).tilino,
      depreciation_remainder_handling: 'S'
    }
    refute @commodity.can_be_sold?(invalidparams)

    # Invalid sales date 2
    invalidparams[:deactivated_at] = Date.today+1
    refute @commodity.can_be_sold?(invalidparams)

    # Invalid sales amount
    invalidparams = {
      amount_sold: -1,
      deactivated_at: Date.today,
      profit_account: accounts(:account_100).tilino,
      depreciation_remainder_handling: 'S'
    }
    refute @commodity.can_be_sold?(invalidparams)
  end

  test 'deactivation prevents further changes' do
    # Commodity in status P turns readonly
    @commodity.status = 'P'
    assert @commodity.status_changed?
    @commodity.save!
    assert @commodity.readonly?
  end
end
