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


  test 'should calculate deprecated amount' do
    assert_equal 2345.0, @commodity.deprecated_sumu_amount
    assert_equal 1001.0, @commodity.deprecated_evl_amount
  end

  test 'should calculate SUMU depreciation with fixed by percentage' do
    params = {
      voucher: nil,
      status: 'A',
      amount: 10000, # hyödykkeen arvo
      planned_depreciation_type: 'P', # Tasapoisto vuosiprosentti
      planned_depreciation_amount: 45 # poistetaan 45% vuodessa hankintasummasta
    }
    @commodity.attributes = params
    @commodity.save!

    # We get 24 rows in total...
    assert_difference('Head::VoucherRow.count', 24) do
      @commodity.generate_rows
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
    refute @commodity.ok_to_generate_rows?

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
      planned_depreciation_type: 'B', # Menojäännöspoisto vuosiprosentti
      planned_depreciation_amount: 20 # poistetaan 20% vuodessa menojäännöksestä
    }

    @commodity.attributes = params
    @commodity.save!

    assert_difference('Head::VoucherRow.count', 24) do
      @commodity.generate_rows
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

    # Rows do not change
    refute @commodity.ok_to_generate_rows?

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
      btl_depreciation_amount: 20, # poistetaan 20% vuodessa menojäännöksestä
    }

    @commodity.attributes = params
    @commodity.save!

    # This commodity already has 2 commodity_rows
    assert_difference('FixedAssets::CommodityRow.count', 4) do
      @commodity.generate_rows
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
      planned_depreciation_type: 'T', # Tasapoisto kuukausittain
      planned_depreciation_amount: 60 # poistetaan 60 kuukaudessa
    }
    @commodity.attributes = params
    @commodity.save!

    assert_difference('Head::VoucherRow.count', 24) do
      @commodity.generate_rows
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

    # Rows do not change
    refute @commodity.ok_to_generate_rows?

    # Test no rows are updated if not needed
    assert @commodity.voucher.rows.collect(&:previous_changes).all?(&:empty?)
  end

  test 'should calculate EVL depreciation with fixed_by_percentage' do
    params = {
      amount: 10000, # hyödykkeen arvo
      status: 'A',
      btl_depreciation_type: 'P', # Tasapoisto vuosiprosentti
      btl_depreciation_amount: 16 # poistetaan 16% vuodessa hankintasummasta
    }
    @commodity.commodity_rows.delete_all
    @commodity.attributes = params
    @commodity.save!

    assert_difference('FixedAssets::CommodityRow.count', 6) do
      @commodity.generate_rows
    end

    # a 6/6 split
    assert_equal 6, @commodity.depreciation_rows.count
    assert_equal 6, @commodity.difference_rows.count

    assert_equal @commodity.commodity_rows.sum(:amount), 1600
    assert_equal @commodity.commodity_rows.first.amount, 270.27
    assert_equal @commodity.commodity_rows.second.amount, 270.27
    assert_equal @commodity.commodity_rows.last.amount, 248.65

    @commodity.reload

    # Rows do not change
    refute @commodity.ok_to_generate_rows?

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
      btl_depreciation_type: 'B', # Menojäännöspoisto vuosiprosentti
      btl_depreciation_amount: 20 # poistetaan 20% vuodessa menojäännöksestä
    }
    @commodity.commodity_rows.delete_all
    @commodity.attributes = params
    @commodity.save!

    assert_difference('FixedAssets::CommodityRow.count', 6) do
      @commodity.generate_rows
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

    # Rows do not change
    refute @commodity.ok_to_generate_rows?

    # Test no rows are updated if not needed
    assert @commodity.commodity_rows.collect(&:previous_changes).all?(&:empty?)
  end

  test 'should calculate EVL depreciation with fixed_by_month' do
    params = {
      amount: 10000, # hyödykkeen arvo
      status: 'A',
      btl_depreciation_type: 'T', # Tasapoisto kuukausittain
      btl_depreciation_amount: 60 # poistetaan 60 kuukaudessa
    }
    @commodity.commodity_rows.delete_all
    @commodity.attributes = params
    @commodity.save!

    assert_difference('FixedAssets::CommodityRow.count', 6) do
      @commodity.generate_rows
    end

    # a 6/6 split
    assert_equal 6, @commodity.depreciation_rows.count
    assert_equal 6, @commodity.difference_rows.count

    assert_equal @commodity.commodity_rows.sum(:amount), 1001
    assert_equal @commodity.commodity_rows.first.amount, 166.83
    assert_equal @commodity.commodity_rows.second.amount, 166.83
    assert_equal @commodity.commodity_rows.last.amount, 166.85

    @commodity.reload

    # Rows do not change
    refute @commodity.ok_to_generate_rows?

    # Test no rows are updated if not needed
    assert @commodity.commodity_rows.collect(&:previous_changes).all?(&:empty?)
  end

  test 'should create something' do
    skip
    params = {
      tilikausi_alku: '2015-01-01',
      tilikausi_loppu: '2015-06-30'
    }
    @commodity.company.update_attributes! params

    @commodity.commodity_rows.delete_all
    @commodity.activated_at = '2015-01-01'

    assert_difference('FixedAssets::CommodityRow.count', 6) do
      @commodity.generate_rows
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

  test 'depreciation generation and dates works like they should' do
    skip
    @commodity.depreciation_rows.delete_all
    # Create depreciation rows to past
    params = {
      tilikausi_alku: '2014-10-01',
      tilikausi_loppu: '2014-12-31'
    }
    @commodity.company.update_attributes! params
    @commodity.activated_at = '2014-11-01'
    @commodity.save

    assert_equal 2, @commodity.depreciation_rows.count
    assert_equal 2, @commodity.difference_rows.count

    assert_equal '2014-11-30'.to_date, @commodity.voucher.rows.first.tapvm
    assert_equal '2014-12-31'.to_date, @commodity.voucher.rows.last.tapvm

    assert_equal '2014-11-30'.to_date, @commodity.commodity_rows.first.transacted_at
    assert_equal '2014-12-31'.to_date, @commodity.commodity_rows.last.transacted_at

    # Create depreciation rows to new fiscal period
    params = {
      tilikausi_alku: '2015-01-01',
      tilikausi_loppu: '2015-12-31'
    }
    @commodity.company.update_attributes! params

    # At this point, updating open fiscal period should trigger generation of rows
    @commodity.save

    assert_equal 14, @commodity.depreciation_rows.count
    assert_equal 14, @commodity.difference_rows.count

    assert_equal '2014-11-30'.to_date, @commodity.voucher.rows.first.tapvm
    assert_equal '2015-01-31'.to_date, @commodity.voucher.rows.third.tapvm
    assert_equal '2015-12-31'.to_date, @commodity.voucher.rows.last.tapvm

    assert_equal '2014-11-30'.to_date, @commodity.commodity_rows.first.transacted_at
    assert_equal '2015-01-31'.to_date, @commodity.commodity_rows.third.transacted_at
    assert_equal '2015-12-31'.to_date, @commodity.commodity_rows.last.transacted_at
  end
end
