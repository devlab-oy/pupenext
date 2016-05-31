require 'test_helper'

class FixedAssets::CommodityTest < ActiveSupport::TestCase
  fixtures %w(
    accounts
    fiscal_years
    fixed_assets/commodities
    fixed_assets/commodity_rows
    head/voucher_rows
    heads
    sum_levels
  )

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

  test 'procurement amount' do
    @commodity.transferred_procurement_amount = 0.0
    assert_equal @commodity.procurement_rows.sum(:summa), @commodity.procurement_amount

    transfered_amount = 1003.35
    @commodity.transferred_procurement_amount = transfered_amount
    assert_equal transfered_amount, @commodity.procurement_amount
  end

  test 'required fields when activated' do
    new_commodity = @commodity.company.commodities.new
    new_commodity.name = 'Kissa'
    new_commodity.description = 'Mirrinen'
    assert new_commodity.valid?, new_commodity.errors.full_messages

    new_commodity.status = 'A'
    refute new_commodity.valid?, "should not be valid"
  end

  test 'cannot set active unless we have procurement rows' do
    assert_not_equal 0, @commodity.procurement_rows.count
    @commodity.status = 'A'
    assert @commodity.valid?

    @commodity.procurement_rows.delete_all
    @commodity.status = 'A'
    refute @commodity.valid?, @commodity.errors.full_messages
  end

  test 'activation succeeds on open period' do
    params = {
      tilikausi_alku: '2015-01-01',
      tilikausi_loppu: '2015-03-31'
    }

    voucher_row = head_voucher_rows(:eleven)
    params_for_new = {
      name: 'Kettu',
      description: 'Repolainen',
      planned_depreciation_type: 'T',
      planned_depreciation_amount: 20.0,
      btl_depreciation_type: 'T',
      btl_depreciation_amount: 20.0
    }

    @commodity.company.attributes = params
    new_commodity = @commodity.company.commodities.new params_for_new
    new_commodity.save!
    # link procurement row
    voucher_row.commodity_id = new_commodity.id
    voucher_row.save!

    new_commodity.activated_at = '2015-01-01'
    new_commodity.status = 'A'
    assert new_commodity.valid?, new_commodity.errors.full_messages
  end

  test 'activation fails on closed period' do
    params = {
      tilikausi_alku: '2015-01-01',
      tilikausi_loppu: '2015-03-31'
    }

    voucher_row = head_voucher_rows(:eleven)
    params_for_new = {
      name: 'Kettu',
      description: 'Repolainen',
      planned_depreciation_type: 'T',
      planned_depreciation_amount: 20.0,
      btl_depreciation_type: 'T',
      btl_depreciation_amount: 20.0
    }

    @commodity.company.attributes = params
    new_commodity = @commodity.company.commodities.new params_for_new
    new_commodity.save!
    # link procurement row
    voucher_row.commodity_id = new_commodity.id
    voucher_row.save!

    new_commodity.activated_at = '2015-06-01'
    new_commodity.status = 'A'
    refute new_commodity.valid?, new_commodity.errors.full_messages
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
    assert_equal 8800, @commodity.bookkeeping_value(Date.today.beginning_of_month)
    assert_equal 6500, @commodity.bookkeeping_value

    # Sold commodity bkvalue is 0
    salesparams = {
      amount_sold: @commodity.amount,
      deactivated_at: Date.today,
      profit_account: accounts(:account_100),
      sales_account: accounts(:account_110),
      depreciation_remainder_handling: 'S',
    }
    @commodity.attributes = salesparams
    @commodity.save!

    CommodityRowGenerator.new(commodity_id: @commodity.id, user_id: users(:bob).id).sell
    @commodity.reload

    assert_equal 'P', @commodity.status
    assert_equal 0, @commodity.bookkeeping_value
  end

  test 'current btl value works with or without history amount' do
    # EVL arvo tilikauden lopussa
    @commodity.status = 'A'

    CommodityRowGenerator.new(commodity_id: @commodity.id, user_id: users(:bob).id).generate_rows
    assert_equal 6000.0, @commodity.btl_value

    # Toisesta järjestelmästä perityt poistot
    @commodity.previous_btl_depreciations = 5000.0
    @commodity.save!

    CommodityRowGenerator.new(commodity_id: @commodity.id, user_id: users(:bob).id).generate_rows

    assert_equal 3000.0, @commodity.btl_value
  end

  test 'cant be sold with invalid params' do
    validparams = {
      amount_sold: 9800,
      deactivated_at: Date.today,
      profit_account: accounts(:account_100),
      sales_account: accounts(:account_110),
      depreciation_remainder_handling: 'S'
    }
    @commodity.attributes = validparams
    assert @commodity.can_be_sold?, 'Should be valid'

    # Invalid status
    @commodity.status = ''
    refute @commodity.can_be_sold?, 'Status should be invalid'

    # Invalid profit account
    invalidparams = {
      amount_sold: 9800,
      deactivated_at: Date.today,
      profit_account: nil,
      sales_account: accounts(:account_110),
      depreciation_remainder_handling: 'S'
    }
    @commodity.status = 'A'
    @commodity.attributes = invalidparams
    refute @commodity.can_be_sold?, 'Profit account should be invalid'

    # Invalid depreciation handling
    invalidparams = {
      amount_sold: 9800,
      deactivated_at: Date.today,
      profit_account: accounts(:account_100),
      sales_account: accounts(:account_110),
      depreciation_remainder_handling: 'K'
    }
    @commodity.attributes = invalidparams
    refute @commodity.can_be_sold?, 'Depreciation handling should be invalid'

    # Invalid sales date
    invalidparams = {
      amount_sold: 9800,
      deactivated_at: @commodity.company.open_period.first - 1,
      profit_account: accounts(:account_100),
      sales_account: accounts(:account_110),
      depreciation_remainder_handling: 'S'
    }
    @commodity.attributes = invalidparams
    refute @commodity.can_be_sold?, 'Sales date should be invalid ( < open period )'

    # Invalid sales date 2
    @commodity.deactivated_at = Date.today+1
    refute @commodity.can_be_sold?, 'Sales date should be invalid ( > today)'

    # Invalid sales amount
    invalidparams = {
      amount_sold: -1,
      deactivated_at: Date.today,
      profit_account: accounts(:account_100),
      sales_account: accounts(:account_110),
      depreciation_remainder_handling: 'S'
    }
    @commodity.attributes = invalidparams
    refute @commodity.can_be_sold?, 'Sales amount should be invalid'
  end

  test 'deactivation prevents further changes' do
    # Commodity in status P turns readonly
    @commodity.status = 'P'
    assert @commodity.status_changed?
    @commodity.save!

    @commodity.name = 'bob'
    assert_raises(ActiveRecord::ReadOnlyRecord) { @commodity.save }
  end

  test 'can be destroyed works' do
    # Cant be destroyed with commodity_rows && voucher rows present
    assert_equal false, @commodity.can_be_destroyed?

    @commodity.commodity_rows.update_all(amended: true)
    # Cant be destroyed with just voucher rows present
    assert_equal false, @commodity.can_be_destroyed?

    @commodity.voucher.rows.update_all(korjattu: 'X')
    @commodity.commodity_rows.build
    # Cant be destroyed with just commodity_rows present
    assert_equal false, @commodity.can_be_destroyed?

    @commodity.commodity_rows.delete_all

    # Can be destroyed with no commodity_rows and voucher rows present
    assert_equal true, @commodity.can_be_destroyed?
  end
end
