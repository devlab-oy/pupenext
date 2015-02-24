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

  test 'should update lock' do
    @commodity.voucher.rows.first.lukko = ''
    @commodity.commodity_rows.first.locked = false
    @commodity.lock_rows

    assert_equal 'X', @commodity.voucher.rows.first.lukko
    assert_equal true, @commodity.commodity_rows.first.locked
  end

  test 'procurement_rows can have only one account number' do
    new_row = head_voucher_rows(:six).dup
    assert new_row.valid? new_row.errors.full_messages

    assert @commodity.valid?, @commodity.errors.full_messages

    new_row.tilino = 1234
    refute new_row.valid?, "should not be valid"
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
    [100.01, 101, 0].each do |p|
      @commodity.planned_depreciation_amount = p
      @commodity.planned_depreciation_type = 'T'
      assert @commodity.valid?,

      @commodity.planned_depreciation_type = 'P'
      refute @commodity.valid?

      @commodity.planned_depreciation_type = 'B'
      refute @commodity.valid?
    end
  end

  test 'should calculate deprecated amount' do
    assert_equal 2345.0, @commodity.deprecated_sumu_amount
    assert_equal 1001.0, @commodity.deprecated_evl_amount
  end

  test 'should calculate with divide_to_payments' do
    amount = 1000
    fiscal_year = @commodity.company.months_in_current_fiscal_year
    result = @commodity.divide_to_payments(amount, fiscal_year*2)

    assert_equal fiscal_year, 6
    assert_equal amount/2, result.sum

    assert_equal fiscal_year, result.count
    assert_equal 83.33.to_d, result.first
    assert_equal 83.35.to_d, result.last
  end

  test 'should calculate with fixed by percentage' do
    # Tasapoisto vuosiprosentti
    full_amount = 10000
    percentage = 35

    result = @commodity.fixed_by_percentage(full_amount, percentage)

    assert_equal result.sum, full_amount * percentage / 100
    assert_equal result.first, 833.33
    assert_equal result.second, 833.33
    assert_equal result.last, 166.68
  end

  test 'should calculate with degressive by percentage' do
    # Menojäännöspoisto vuosiprosentti
    # Full amount to be reducted
    reduct = 10000
    fiscal_year = @commodity.company.months_in_current_fiscal_year
    # Yearly degressive percentage
    fiscalyearly_percentage = 35

    result = @commodity.degressive_by_percentage(reduct, fiscalyearly_percentage)
    assert_equal fiscal_year, result.count
    assert_equal 3500, result.sum

    result = @commodity.degressive_by_percentage(reduct, fiscalyearly_percentage, 3500)
    assert_equal fiscal_year, result.count
    assert_equal 2275, result.sum
  end

  test 'should calculate with fixed by month' do
    # Tasapoisto kuukausittain
    # Full amount to be reducted
    total_amount = 10000
    # Total amounts of depreciations
    total_depreciations = 12

    fiscal_year = @commodity.company.months_in_current_fiscal_year

    result = @commodity.fixed_by_month(total_amount, total_depreciations, 6, 5000)

    assert_equal fiscal_year, result.count
    assert_equal 5000, result.sum
  end

  test 'should calculate SUMU depreciation with fixed by percentage' do
    params = {
      voucher: nil,
      status: 'A',
      amount: 10000, # hyödykkeen arvo
      activated_at: Date.today.beginning_of_month, # poistot tästä päivästä eteenpäin
      planned_depreciation_type: 'P', # Tasapoisto vuosiprosentti
      planned_depreciation_amount: 45 # poistetaan 45% vuodessa hankintasummasta
    }
    @commodity.attributes = params

    # We get 24 rows in total...
    assert_difference('Head::VoucherRow.count', 24) do
      @commodity.save
    end

    # ...of which 6 are depreciation and 6 are difference rows
    assert_equal 6, @commodity.depreciation_rows.count
    assert_equal 6, @commodity.difference_rows.count

    # Test no locked rows are updated
    assert @commodity.depreciation_rows.locked.collect(&:previous_changes).all?(&:empty?)

    # Test amounts are set correctly
    assert_equal @commodity.depreciation_rows.sum(:summa), 10000 * 45 / 100
    assert_equal @commodity.depreciation_rows.first.summa, 769.23
    assert_equal @commodity.depreciation_rows.second.summa, 769.23
    assert_equal @commodity.depreciation_rows.last.summa, 653.85

    # counter entries also 6/6
    assert_equal 6, @commodity.counter_depreciation_rows.count
    assert_equal 6, @commodity.counter_difference_rows.count

    # counter entries amounts correct
    assert_equal @commodity.depreciation_rows.first.summa * -1, @commodity.counter_depreciation_rows.first.summa
    assert_equal @commodity.depreciation_rows.last.summa * -1, @commodity.counter_depreciation_rows.last.summa

    btl_one = @commodity.commodity_rows.first
    planned_one = @commodity.depreciation_rows.first
    difference = @commodity.difference_rows.first

    # Difference is calculated correctly
    assert_equal (planned_one.summa - btl_one.amount), difference.summa

    # Difference is set for same date
    assert_equal btl_one.transacted_at, difference.tapvm

    number_one = @commodity.difference_rows.first.tilino
    number_two = @commodity.poistoero_number

    # Difference goes to right account
    assert_equal number_two, number_one

    @commodity.reload

    # Rows do not change
    assert_no_difference('Head::VoucherRow.count') do
      @commodity.save
    end

    # ... still a 6/6 split
    assert_equal 6, @commodity.depreciation_rows.count
    assert_equal 6, @commodity.difference_rows.count

    # counter entries also still 6/6
    assert_equal 6, @commodity.counter_depreciation_rows.count
    assert_equal 6, @commodity.counter_difference_rows.count

    # Test no rows are updated if not needed
    assert @commodity.voucher.rows.collect(&:previous_changes).all?(&:empty?)
  end

  test 'should calculate SUMU depreciation with degressive by percentage' do
    params = {
      voucher: nil,
      amount: 10000, # hyödykkeen arvo
      status: 'A',
      activated_at: Date.today.beginning_of_month, # poistot tästä päivästä eteenpäin
      planned_depreciation_type: 'B', # Menojäännöspoisto vuosiprosentti
      planned_depreciation_amount: 20 # poistetaan 20% vuodessa menojäännöksestä
    }

    @commodity.attributes = params

    assert_difference('Head::VoucherRow.count', 24) do
      @commodity.save
    end

    # ... still a 6/6 split
    assert_equal 6, @commodity.depreciation_rows.count
    assert_equal 6, @commodity.difference_rows.count

    assert_equal @commodity.depreciation_rows.sum(:summa), 10000 * 20 / 100
    assert_equal @commodity.depreciation_rows.first.summa, 333.0
    assert_equal @commodity.depreciation_rows.second.summa, 322.0
    assert_equal @commodity.depreciation_rows.third.summa, 311.0
    assert_equal @commodity.depreciation_rows.fourth.summa, 301.0
    assert_equal @commodity.depreciation_rows.fifth.summa, 291.0
    assert_equal @commodity.depreciation_rows.last.summa, 442.0

    # counter entries also 6/6
    assert_equal 6, @commodity.counter_depreciation_rows.count
    assert_equal 6, @commodity.counter_difference_rows.count

    # counter entries amounts correct
    assert_equal @commodity.depreciation_rows.first.summa * -1, @commodity.counter_depreciation_rows.first.summa
    assert_equal @commodity.depreciation_rows.last.summa * -1, @commodity.counter_depreciation_rows.last.summa

    # Updating commodity should not update any rows
    @commodity.reload
    @commodity.name = 'foo'
    @commodity.description = 'bar'

    assert_no_difference('Head::VoucherRow.count') do
      @commodity.save
    end

    # ... still a 6/6 split
    assert_equal 6, @commodity.depreciation_rows.count
    assert_equal 6, @commodity.difference_rows.count

    # Test no rows are updated if not needed
    assert @commodity.voucher.rows.collect(&:previous_changes).all?(&:empty?)
  end

  test 'when we have to generate all rows' do
    # otsikon tieto muuttui, pitää laskea kaikki
    params = {
      btl_depreciation_type: 'B', # Menojäännöspoisto vuosiprosentti
      btl_depreciation_amount: 20 # poistetaan 20% vuodessa menojäännöksestä
    }

    @commodity.attributes = params
    # This commodity already has 2 commodity_rows
    assert_difference('FixedAssets::CommodityRow.count', 4) do
      @commodity.save
    end

    # ... still a 6/6 split
    assert_equal 6, @commodity.depreciation_rows.count
    assert_equal 6, @commodity.difference_rows.count

    assert_equal 6, @commodity.commodity_rows.collect(&:previous_changes).count
  end

  test 'should calculate SUMU depreciation with fixed_by_month' do
    params = {
      voucher: nil,
      amount: 10000, # hyödykkeen arvo
      status: 'A',
      activated_at: Date.today.beginning_of_month, # poistot tästä päivästä eteenpäin
      planned_depreciation_type: 'T', # Tasapoisto kuukausittain
      planned_depreciation_amount: 60 # poistetaan 60 kuukaudessa
    }
    @commodity.attributes = params

    assert_difference('Head::VoucherRow.count', 24) do
      @commodity.save
    end

    # ... still a 6/6 split
    assert_equal 6, @commodity.depreciation_rows.count
    assert_equal 6, @commodity.difference_rows.count


    assert_equal @commodity.depreciation_rows.sum(:summa), 1001
    assert_equal @commodity.depreciation_rows.first.summa, 166.83
    assert_equal @commodity.depreciation_rows.second.summa, 166.83
    assert_equal @commodity.depreciation_rows.last.summa, 166.85

    # counter entries also 6/6
    assert_equal 6, @commodity.counter_depreciation_rows.count
    assert_equal 6, @commodity.counter_difference_rows.count

    # counter entries amounts correct
    assert_equal @commodity.depreciation_rows.first.summa * -1, @commodity.counter_depreciation_rows.first.summa
    assert_equal @commodity.depreciation_rows.last.summa * -1, @commodity.counter_depreciation_rows.last.summa

    @commodity.reload

    assert_no_difference('Head::VoucherRow.count') do
      @commodity.save
    end

    # Test no rows are updated if not needed
    assert @commodity.voucher.rows.collect(&:previous_changes).all?(&:empty?)
  end

  test 'should calculate EVL depreciation with fixed_by_percentage' do
    params = {
      amount: 10000, # hyödykkeen arvo
      status: 'A',
      activated_at: Date.today.beginning_of_month, # poistot tästä päivästä eteenpäin
      btl_depreciation_type: 'P', # Tasapoisto vuosiprosentti
      btl_depreciation_amount: 16 # poistetaan 16% vuodessa hankintasummasta
    }
    @commodity.commodity_rows.delete_all
    @commodity.attributes = params

    assert_difference('FixedAssets::CommodityRow.count', 6) do
      @commodity.save
    end

    # a 6/6 split
    assert_equal 6, @commodity.depreciation_rows.count
    assert_equal 6, @commodity.difference_rows.count

    assert_equal @commodity.commodity_rows.sum(:amount), 1600
    assert_equal @commodity.commodity_rows.first.amount, 270.27
    assert_equal @commodity.commodity_rows.second.amount, 270.27
    assert_equal @commodity.commodity_rows.last.amount, 248.65

    @commodity.reload

    assert_no_difference('FixedAssets::CommodityRow.count') do
      @commodity.save
    end

    # a 6/6 split
    assert_equal 6, @commodity.depreciation_rows.count
    assert_equal 6, @commodity.difference_rows.count

    # Test no rows are updated if not needed
    assert @commodity.commodity_rows.collect(&:previous_changes).all?(&:empty?)
  end

  test 'should calculate EVL depreciation with degressive_by_percentage' do
    params = {
      amount: 10000, # hyödykkeen arvo
      status: 'A',
      activated_at: Date.today.beginning_of_month, # poistot tästä päivästä eteenpäin
      btl_depreciation_type: 'B', # Menojäännöspoisto vuosiprosentti
      btl_depreciation_amount: 20 # poistetaan 20% vuodessa menojäännöksestä
    }
    @commodity.commodity_rows.delete_all
    @commodity.attributes = params

    assert_difference('FixedAssets::CommodityRow.count', 6) do
      @commodity.save
    end

    # a 6/6 split
    assert_equal 6, @commodity.depreciation_rows.count
    assert_equal 6, @commodity.difference_rows.count

    assert_equal @commodity.commodity_rows.sum(:amount), 10000 * 20 / 100
    assert_equal @commodity.commodity_rows.first.amount, 333.0
    assert_equal @commodity.commodity_rows.second.amount, 322.0
    assert_equal @commodity.commodity_rows.third.amount, 311.0
    assert_equal @commodity.commodity_rows.fourth.amount, 301.0
    assert_equal @commodity.commodity_rows.fifth.amount, 291.0
    assert_equal @commodity.commodity_rows.last.amount, 442.0

    @commodity.reload

    assert_no_difference('FixedAssets::CommodityRow.count') do
      @commodity.save
    end

    # Test no rows are updated if not needed
    assert @commodity.commodity_rows.collect(&:previous_changes).all?(&:empty?)
  end

  test 'should calculate EVL depreciation with fixed_by_month' do
    params = {
      amount: 10000, # hyödykkeen arvo
      status: 'A',
      activated_at: Date.today.beginning_of_month, # poistot tästä päivästä eteenpäin
      btl_depreciation_type: 'T', # Tasapoisto kuukausittain
      btl_depreciation_amount: 60 # poistetaan 60 kuukaudessa
    }
    @commodity.commodity_rows.delete_all
    @commodity.attributes = params

    assert_difference('FixedAssets::CommodityRow.count', 6) do
      @commodity.save
    end

    # a 6/6 split
    assert_equal 6, @commodity.depreciation_rows.count
    assert_equal 6, @commodity.difference_rows.count

    assert_equal @commodity.commodity_rows.sum(:amount), 1001
    assert_equal @commodity.commodity_rows.first.amount, 166.83
    assert_equal @commodity.commodity_rows.second.amount, 166.83
    assert_equal @commodity.commodity_rows.last.amount, 166.85

    @commodity.reload

    assert_no_difference('FixedAssets::CommodityRow.count') do
      @commodity.save
    end

    # Test no rows are updated if not needed
    assert @commodity.commodity_rows.collect(&:previous_changes).all?(&:empty?)
  end

  test 'should create something' do
    params = {
      tilikausi_alku: '2015-01-01',
      tilikausi_loppu: '2015-06-30'
    }
    @commodity.company.update_attributes! params

    @commodity.commodity_rows.delete_all
    @commodity.activated_at = '2015-01-01'

    assert_difference('FixedAssets::CommodityRow.count', 6) do
      @commodity.save
    end

    # a 6/6 split
    assert_equal 6, @commodity.depreciation_rows.count
    assert_equal 6, @commodity.difference_rows.count

    assert_equal '2015-01-31'.to_date, @commodity.commodity_rows.first.transacted_at
    assert_equal '2015-06-30'.to_date, @commodity.commodity_rows.last.transacted_at

    @commodity.commodity_rows.delete_all
    @commodity.activated_at = '2016-01-01'

    params = {
      tilikausi_alku: '2016-01-01',
      tilikausi_loppu: '2016-12-31'
    }
    @commodity.company.update_attributes! params

    assert_difference('FixedAssets::CommodityRow.count', 12) do
      @commodity.save
    end

    assert_equal 12, @commodity.depreciation_rows.count
    assert_equal 12, @commodity.difference_rows.count

    assert_equal '2016-01-31'.to_date, @commodity.commodity_rows.first.transacted_at
    assert_equal '2016-12-31'.to_date, @commodity.commodity_rows.last.transacted_at

    @commodity.commodity_rows.delete_all
    @commodity.activated_at = '2016-06-01'

    assert_difference('FixedAssets::CommodityRow.count', 7) do
      @commodity.save
    end

    assert_equal 7, @commodity.depreciation_rows.count
    assert_equal 7, @commodity.difference_rows.count

    assert_equal '2016-06-30'.to_date, @commodity.commodity_rows.first.transacted_at
    assert_equal '2016-12-31'.to_date, @commodity.commodity_rows.last.transacted_at

    params = {
      tilikausi_alku: '2015-01-01',
      tilikausi_loppu: '2016-03-31'
    }
    @commodity.company.update_attributes! params
    @commodity.commodity_rows.delete_all
    @commodity.activated_at = '2015-01-01'

    assert_difference('FixedAssets::CommodityRow.count', 15) do
      @commodity.save
    end

    assert_equal 15, @commodity.depreciation_rows.count
    assert_equal 15, @commodity.difference_rows.count

    assert_equal '2015-01-31'.to_date, @commodity.commodity_rows.first.transacted_at
    assert_equal '2016-03-31'.to_date, @commodity.commodity_rows.last.transacted_at
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

  test 'should get difference rows between two dates' do
    assert_equal 1, @commodity.difference_rows_between(Date.today, Date.today.advance(months: +1)).count
    assert_equal 0, @commodity.difference_rows_between(Date.yesterday-1, Date.yesterday).count
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

    assert_equal params[:tilino], @commodity.procurement_number
    assert_equal params[:kustp], @commodity.procurement_cost_centre
    assert_equal params[:projekti], @commodity.procurement_project
    assert_equal params[:kohde], @commodity.procurement_target

    @commodity.procurement_rows.delete_all
    assert_nil @commodity.procurement_number
    assert_nil @commodity.procurement_cost_centre
    assert_nil @commodity.procurement_project
    assert_nil @commodity.procurement_target
  end

  test 'linkable invoices method works' do
    assert_equal 2, @commodity.linkable_invoices.count
    @commodity.procurement_rows.delete_all
    assert_equal 3, @commodity.linkable_invoices.count
  end

  test 'linkable vouchers method works' do
    assert_equal 2, @commodity.linkable_vouchers.count
    @commodity.procurement_rows.delete_all
    assert_equal 3, @commodity.linkable_vouchers.count
  end

end
