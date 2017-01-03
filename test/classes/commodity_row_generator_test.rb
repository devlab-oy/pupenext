require 'test_helper'

class CommodityRowGeneratorTest < ActiveSupport::TestCase
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
    @commodity.activated_at = Time.zone.today
    @commodity.save!

    @company = companies(:acme)

    @fiscal_year = fiscal_years(:two)
    @fiscal_year.tilikausi_alku = @company.tilikausi_alku
    @fiscal_year.tilikausi_loppu = @company.tilikausi_loppu
    @fiscal_year.save!

    @bob = users(:bob)
    @generator = CommodityRowGenerator.new(commodity_id: @commodity.id, user_id: @bob.id)
  end

  test 'fixture is correct for calculations' do
    # We have a 12 month fiscal year
    fiscal_year = @commodity.company.current_fiscal_year.map(&:end_of_month).uniq.count
    assert_equal 12, fiscal_year

    # We activate on today (seventh month from fiscal start)
    assert_equal Time.zone.today, @commodity.activated_at
  end

  test 'should calculate with fixed by percentage' do
    # Tasapoisto vuosiprosentti
    full_amount = 10000.0
    percentage = 35.0
    result = @generator.fixed_by_percentage(full_amount, percentage)

    assert_equal result.sum, full_amount * percentage / 100.0
    assert_equal result.first, 588.24
    assert_equal result.second, 588.24
    assert_equal result.last, 558.8
  end

  test 'should round correctly' do
    # Tasapoisto vuosiprosentti
    full_amount = 1248.83
    percentage = 35
    result = @generator.fixed_by_percentage(full_amount, percentage)

    assert_equal result.sum, (full_amount * percentage / 100).round(2)
    assert_equal result.first, 73.46.to_d
    assert_equal result.second, 73.46.to_d
    assert_equal result.last, 69.79.to_d
  end

  test 'should not generate rows over fiscal period' do
    reduct = 1019.70
    fiscalyearly_percentage = 25
    @commodity.activated_at = @company.tilikausi_loppu.beginning_of_month
    @commodity.save!

    generator = CommodityRowGenerator.new(commodity_id: @commodity.id, user_id: @bob.id, fiscal_id: @fiscal_year.id)
    generator.generate_rows
    result = generator.degressive_by_percentage(reduct, fiscalyearly_percentage)
    assert_equal 1019.69, result.sum
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

    # Test EVL-side rounding with more complex amounts
    reduct = 1837453.67
    fiscalyearly_percentage = 4.0

    result = @generator.degressive_by_percentage(reduct, fiscalyearly_percentage)
    assert_equal result.sum, (reduct * fiscalyearly_percentage / 100).round(2).to_d

    assert_equal result.sum, 73498.15.to_d

    # Test incl. history amount
    @commodity.procurement_rows.first.summa = 1837453.67
    @commodity.procurement_rows.first.save!

    commodity_amount = 1837453.67
    head_voucher_rows(:six).summa = commodity_amount
    head_voucher_rows(:six).save!

    # Tämä on siirretty EVL arvo
    history_amount = 1713273.96
    commodity_params = {
      activated_at: @company.tilikausi_alku,
      previous_btl_depreciations: history_amount,
      planned_depreciation_type: 'T',
      planned_depreciation_amount: 228.0,
      btl_depreciation_type: 'B',
      btl_depreciation_amount: 4.0,
    }

    @commodity.attributes = commodity_params
    @commodity.save!
    @commodity = @commodity.reload

    assert_equal commodity_amount.to_d, @commodity.amount

    generator = CommodityRowGenerator.new(commodity_id: @commodity.id, user_id: @bob.id)
    generator.generate_rows
    assert_equal -68530.96.to_d, @commodity.commodity_rows.sum(:amount)
    assert_equal 96708.09, @commodity.depreciation_rows.sum(:summa)
    assert_equal -28177.13, @commodity.depreciation_difference_rows.sum(:summa)
  end

  test 'should calculate with fixed by month' do
    # 1st case
    total_depreciations = 60
    total_amount = 49716.55

    # Re-Initialize generator with new fiscal values
    generator = CommodityRowGenerator.new(commodity_id: @commodity.id, user_id: @bob.id)
    result = generator.fixed_by_month(total_amount, total_depreciations)
    assert_equal result.first, 828.61
    assert_equal result.last, 828.61
    assert_equal result.sum, 4971.66

    # 2nd case
    # Tasapoisto kuukausittain
    # Full amount to be reducted
    total_amount = 2583.38
    # Total amounts of depreciations
    total_depreciations = 24

    # Create superlong fiscal period for measure
    superlong_fiscal = @commodity.company.fiscal_years.first.dup
    FiscalYear.delete_all
    superlong_fiscal.tilikausi_alku = 60.months.ago
    superlong_fiscal.tilikausi_loppu = Time.zone.today.advance(months: 12)
    superlong_fiscal.save!

    @commodity.company.tilikausi_alku = 60.months.ago
    @commodity.company.tilikausi_loppu = Time.zone.today.advance(months: 12)
    @commodity.company.save!

    @commodity.activated_at = 24.months.ago
    assert @commodity.valid?
    @commodity.save!

    # Re-Initialize generator with new fiscal values
    generator = CommodityRowGenerator.new(commodity_id: @commodity.id, user_id: @bob.id)
    result = generator.fixed_by_month(total_amount, total_depreciations)

    assert_equal 25, result.count
    assert_equal total_amount, result.sum
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
      CommodityRowGenerator.new(commodity_id: @commodity.id, user_id: @bob.id).generate_rows
    end

    @commodity.reload

    # ...of which all are created by the same user
    assert_equal [@bob.kuka], @commodity.voucher.rows.map(&:laatija).uniq
    assert_equal [@bob.kuka], @commodity.fixed_assets_rows.map(&:laatija).uniq
    assert_equal [@bob.kuka], @commodity.depreciation_rows.map(&:laatija).uniq
    assert_equal [@bob.kuka], @commodity.depreciation_difference_rows.map(&:laatija).uniq
    assert_equal [@bob.kuka], @commodity.depreciation_difference_change_rows.map(&:laatija).uniq

    # ...of which 6 are depreciation and 6 are difference rows
    assert_equal 6, @commodity.fixed_assets_rows.count
    assert_equal 6, @commodity.depreciation_difference_rows.count

    # Test no locked rows are updated
    assert @commodity.fixed_assets_rows.locked.collect(&:previous_changes).all?(&:empty?)

    # Test amounts are set correctly
    assert_equal @commodity.fixed_assets_rows.sum(:summa), -10000 * 45 / 100
    assert_equal @commodity.fixed_assets_rows.first.summa, -769.23
    assert_equal @commodity.fixed_assets_rows.second.summa, -769.23
    assert_equal @commodity.fixed_assets_rows.last.summa, -653.85

    # counter entries also 6/6
    assert_equal 6, @commodity.depreciation_rows.count
    assert_equal 6, @commodity.depreciation_difference_change_rows.count

    # counter entries amounts correct
    assert_equal @commodity.fixed_assets_rows.first.summa * -1, @commodity.depreciation_rows.first.summa
    assert_equal @commodity.fixed_assets_rows.last.summa * -1, @commodity.depreciation_rows.last.summa

    btl_one = @commodity.commodity_rows.first
    planned_one = @commodity.fixed_assets_rows.first
    difference = @commodity.depreciation_difference_rows.first

    # Difference is calculated correctly
    assert_equal (planned_one.summa - btl_one.amount), difference.summa

    # Difference is set for same date
    assert_equal btl_one.transacted_at, difference.tapvm

    number_one = @commodity.depreciation_difference_rows.first.tilino
    number_two = @commodity.depreciation_difference_account

    # Difference goes to right account
    assert_equal number_two, number_one

    @commodity.reload

    # Rows do not change
    refute @commodity.ok_to_generate_rows?

    # ... still a 6/6 split
    assert_equal 6, @commodity.fixed_assets_rows.count
    assert_equal 6, @commodity.depreciation_difference_rows.count

    # counter entries also still 6/6
    assert_equal 6, @commodity.depreciation_rows.count
    assert_equal 6, @commodity.depreciation_difference_change_rows.count

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
      CommodityRowGenerator.new(commodity_id: @commodity.id, user_id: @bob.id).generate_rows
    end

    @commodity.reload

    # ... still a 6/6 split
    assert_equal 6, @commodity.fixed_assets_rows.count
    assert_equal 6, @commodity.depreciation_difference_rows.count

    assert_equal @commodity.fixed_assets_rows.sum(:summa), -10000 * 20 / 100
    assert_equal @commodity.fixed_assets_rows.first.summa, -333.33
    assert_equal @commodity.fixed_assets_rows.second.summa, -322.22
    assert_equal @commodity.fixed_assets_rows.third.summa, -311.48
    assert_equal @commodity.fixed_assets_rows.fourth.summa, -301.1
    assert_equal @commodity.fixed_assets_rows.fifth.summa, -291.06
    assert_equal @commodity.fixed_assets_rows.last.summa, -440.81

    # counter entries also 6/6
    assert_equal 6, @commodity.depreciation_rows.count
    assert_equal 6, @commodity.depreciation_difference_change_rows.count

    # counter entries amounts correct
    assert_equal @commodity.fixed_assets_rows.first.summa * -1, @commodity.depreciation_rows.first.summa
    assert_equal @commodity.fixed_assets_rows.last.summa * -1, @commodity.depreciation_rows.last.summa

    # Updating commodity should not update any rows
    @commodity.reload
    @commodity.name = 'foo'
    @commodity.description = 'bar'

    # Rows do not change
    refute @commodity.ok_to_generate_rows?

    # ... still a 6/6 split
    assert_equal 6, @commodity.fixed_assets_rows.count
    assert_equal 6, @commodity.depreciation_difference_rows.count

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
      CommodityRowGenerator.new(commodity_id: @commodity.id, user_id: @bob.id).generate_rows
    end

    @commodity.reload

    # ... still a 6/6 split
    assert_equal 6, @commodity.fixed_assets_rows.count
    assert_equal 6, @commodity.depreciation_difference_rows.count

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
      CommodityRowGenerator.new(commodity_id: @commodity.id, user_id: @bob.id).generate_rows
    end

    @commodity.reload

    # ... still a 6/6 split
    assert_equal 6, @commodity.fixed_assets_rows.count
    assert_equal 6, @commodity.depreciation_difference_rows.count


    assert_equal @commodity.fixed_assets_rows.sum(:summa), -1000.0
    assert_equal @commodity.fixed_assets_rows.first.summa, -166.67
    assert_equal @commodity.fixed_assets_rows.second.summa, -166.67
    assert_equal @commodity.fixed_assets_rows.last.summa, -166.65

    # counter entries also 6/6
    assert_equal 6, @commodity.depreciation_rows.count
    assert_equal 6, @commodity.depreciation_difference_change_rows.count

    # counter entries amounts correct
    assert_equal @commodity.fixed_assets_rows.first.summa * -1, @commodity.depreciation_rows.first.summa
    assert_equal @commodity.fixed_assets_rows.last.summa * -1, @commodity.depreciation_rows.last.summa

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
      CommodityRowGenerator.new(commodity_id: @commodity.id, user_id: @bob.id).generate_rows
    end

    @commodity.reload

    # a 6/6 split
    assert_equal 6, @commodity.fixed_assets_rows.count
    assert_equal 6, @commodity.depreciation_difference_rows.count

    assert_equal @commodity.commodity_rows.sum(:amount), -1600
    assert_equal @commodity.commodity_rows.first.amount, -270.27
    assert_equal @commodity.commodity_rows.second.amount, -270.27
    assert_equal @commodity.commodity_rows.last.amount, -248.65

    @commodity.reload

    # Rows do not change
    refute @commodity.ok_to_generate_rows?

    # a 6/6 split
    assert_equal 6, @commodity.fixed_assets_rows.count
    assert_equal 6, @commodity.depreciation_difference_rows.count

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
      CommodityRowGenerator.new(commodity_id: @commodity.id, user_id: @bob.id).generate_rows
    end

    @commodity.reload

    # a 6/6 split
    assert_equal 6, @commodity.fixed_assets_rows.count
    assert_equal 6, @commodity.depreciation_difference_rows.count

    assert_equal @commodity.commodity_rows.sum(:amount), -10000 * 20 / 100
    assert_equal @commodity.commodity_rows.first.amount, -333.33
    assert_equal @commodity.commodity_rows.second.amount, -322.22
    assert_equal @commodity.commodity_rows.third.amount, -311.48
    assert_equal @commodity.commodity_rows.fourth.amount, -301.1
    assert_equal @commodity.commodity_rows.fifth.amount, -291.06
    assert_equal @commodity.commodity_rows.last.amount, -440.81

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
      CommodityRowGenerator.new(commodity_id: @commodity.id, user_id: @bob.id).generate_rows
    end

    @commodity.reload

    # a 6/6 split
    assert_equal 6, @commodity.fixed_assets_rows.count
    assert_equal 6, @commodity.depreciation_difference_rows.count

    assert_equal @commodity.commodity_rows.sum(:amount), -1000.0
    assert_equal @commodity.commodity_rows.first.amount, -166.67
    assert_equal @commodity.commodity_rows.second.amount, -166.67
    assert_equal @commodity.commodity_rows.last.amount, -166.65

    @commodity.reload

    # Rows do not change
    refute @commodity.ok_to_generate_rows?

    # Test no rows are updated if not needed
    assert @commodity.commodity_rows.collect(&:previous_changes).all?(&:empty?)
  end

  test 'depreciation generation and dates works like they should in past' do
    # Simulate fresh start
    @commodity.voucher.rows.destroy_all
    @commodity.commodity_rows.destroy_all

    # Open fiscal periods for 2014 - 2015
    params = {
      tilikausi_alku: Time.zone.today.beginning_of_year.last_year,
      tilikausi_loppu: Time.zone.today.end_of_year.last_year,
    }
    @commodity.company.update_attributes! params

    # Create depreciation rows for previous year
    params = {
      commodity_id: @commodity.id,
      fiscal_id: fiscal_years(:one).id,
      user_id: @bob.id,
    }

    # Activate commodity on november last year
    previous_year_activation = Time.zone.today.beginning_of_month.last_year.change(month: 11)
    @commodity.activated_at = previous_year_activation
    @commodity.save!
    assert_equal 0.0, @commodity.accumulated_depreciation_at(Time.zone.today)
    @generator = CommodityRowGenerator.new(params).generate_rows
    @commodity.reload

    assert_equal 2, @commodity.fixed_assets_rows.count, "poistot"
    assert_equal 2, @commodity.depreciation_difference_rows.count, "poistoero"

    rows = @commodity.voucher.rows.order(:tapvm)
    assert_equal previous_year_activation.end_of_month, rows.first.tapvm
    assert_equal previous_year_activation.next_month.end_of_month, rows.last.tapvm

    rows = @commodity.commodity_rows.order(:transacted_at)
    assert_equal previous_year_activation.end_of_month.to_date, rows.first.transacted_at
    assert_equal previous_year_activation.next_month.end_of_month, rows.last.transacted_at

    assert_equal 3500.0, @commodity.accumulated_depreciation_at(Time.zone.today)
  end

  test 'depreciation generation and dates works like they should in current' do
    # Create depreciation rows to current fiscal period
    params = {
      commodity_id: @commodity.id,
      fiscal_id: @fiscal_year.id,
      user_id: @bob.id
    }

    @commodity.activated_at = @company.tilikausi_alku
    @commodity.save!
    @commodity.reload

    @generator = CommodityRowGenerator.new(params).generate_rows

    assert_equal 12, @commodity.fixed_assets_rows.count, "poistot"
    assert_equal 12, @commodity.depreciation_difference_rows.count, "poistoero"

    rows = @commodity.fixed_assets_rows.order(tapvm: :asc)
    assert_equal @company.tilikausi_alku.end_of_month, rows.first.tapvm
    assert_equal @company.tilikausi_alku.end_of_month, rows[-12].tapvm
    assert_equal @company.tilikausi_loppu.end_of_month, rows.last.tapvm

    rows = @commodity.commodity_rows.order(transacted_at: :asc)
    assert_equal @company.tilikausi_alku.end_of_month, rows.first.transacted_at
    assert_equal @company.tilikausi_alku.end_of_month, rows[-12].transacted_at
    assert_equal @company.tilikausi_loppu.end_of_month, rows.last.transacted_at

    assert_equal 1764.72, @commodity.accumulated_depreciation_at(Time.zone.today.beginning_of_month)
  end

  test 'rows split' do
    row = head_voucher_rows(:nine)
    row.commodity_id = @commodity.id
    row.kustp = 10
    row.save!

    @commodity.status = 'A'
    @commodity.save!

    CommodityRowGenerator.new(commodity_id: @commodity.id, user_id: @bob.id).generate_rows
    @commodity.reload

    # 24 rows split into 2 (with different cost_centres), all share same user
    assert_equal 48, @commodity.voucher.rows.count
    assert_equal [0, 10], @commodity.voucher.rows.map(&:kustp).uniq
    assert_equal [@bob.kuka], @commodity.voucher.rows.map(&:laatija).uniq

    # Check all of the 48 rows separately
    assert_equal 12, @commodity.fixed_assets_rows.count
    assert_equal [0, 10], @commodity.fixed_assets_rows.map(&:kustp).uniq
    assert_equal [@bob.kuka], @commodity.fixed_assets_rows.map(&:laatija).uniq

    assert_equal 12, @commodity.depreciation_rows.count
    assert_equal [0, 10], @commodity.depreciation_rows.map(&:kustp).uniq
    assert_equal [@bob.kuka], @commodity.depreciation_rows.map(&:laatija).uniq

    assert_equal 12, @commodity.depreciation_difference_rows.count
    assert_equal [0, 10], @commodity.depreciation_difference_rows.map(&:kustp).uniq
    assert_equal [@bob.kuka], @commodity.depreciation_difference_rows.map(&:laatija).uniq

    assert_equal 12, @commodity.depreciation_difference_change_rows.count
    assert_equal [0, 10], @commodity.depreciation_difference_change_rows.map(&:kustp).uniq
    assert_equal [@bob.kuka], @commodity.depreciation_difference_change_rows.map(&:laatija).uniq
  end

  test 'sells commodity with valid params' do
    # TODO, this test is broken. can't rely on relative dates
    skip

    salesparams = {
      amount_sold: 9800,
      deactivated_at: Time.zone.today,
      profit_account: accounts(:account_100),
      sales_account: accounts(:account_110),
      depreciation_remainder_handling: 'S',
    }
    @commodity.attributes = salesparams
    @commodity.activated_at = Time.zone.today.beginning_of_year
    @commodity.save!

    CommodityRowGenerator.new(commodity_id: @commodity.id, user_id: @bob.id).generate_rows
    @commodity.reload

    CommodityRowGenerator.new(commodity_id: @commodity.id, user_id: @bob.id).sell
    @commodity.reload

    assert_equal 'P', @commodity.status
    assert_equal salesparams[:deactivated_at], @commodity.deactivated_at
    assert_equal salesparams[:amount_sold], @commodity.amount_sold
    assert_equal salesparams[:depreciation_remainder_handling], @commodity.depreciation_remainder_handling
    assert_equal salesparams[:profit_account].id, @commodity.profit_account.id
    # Sets btl total to negative amount(100%)
    assert_equal @commodity.amount * -1, @commodity.commodity_rows.sum(:amount)

    # Viimeiset 3 kirjausta pitäisi olla myyntikirjaukset
    salesrows = @commodity.voucher.rows.last(3)

    # Myyntivoitto/tappio / profit_account
    assert_equal @commodity.amount - @commodity.amount_sold, salesrows.last.summa
    assert_equal salesparams[:profit_account].tilino, salesrows.last.tilino

    # Myyntisumma / sales_account
    assert_equal salesparams[:amount_sold], salesrows.second.summa
    assert_equal salesparams[:sales_account].tilino, salesrows.second.tilino

    # SUMU-tilin nollaus / fixed_assets_account
    resetting_amount = @commodity.amount + @commodity.fixed_assets_rows.sum(:summa) - salesrows.first.summa
    assert_equal resetting_amount, salesrows.first.summa
    assert_equal @commodity.fixed_assets_account, salesrows.first.tilino

    assert_raises(ArgumentError) do
      CommodityRowGenerator.new(commodity_id: @commodity.id, user_id: @bob.id).sell
    end
  end

  test 'should not create rows before commodity activation date' do
    params = {
      commodity_id: @commodity.id,
      fiscal_id: @fiscal_year.id,
      user_id: @bob.id
    }

    @commodity.update_column(:activated_at, @fiscal_year.tilikausi_alku.advance(months: 3))

    assert @commodity.valid?, @commodity.errors.full_messages
    assert_difference('FixedAssets::CommodityRow.count', 7) do
      CommodityRowGenerator.new(params).generate_rows
    end

    @commodity.update_column(:activated_at, @fiscal_year.tilikausi_loppu.advance(months: 3))
    assert @commodity.valid?, @commodity.errors.full_messages

    # Fails when commodity activated after depreciation_end_date
    assert_raises('ArgumentError') do
      CommodityRowGenerator.new(params).generate_rows
    end
  end

  test 'should delete rows for same period as generated' do
    params = {
      commodity_id: @commodity.id,
      fiscal_id: @fiscal_year.id,
      user_id: @bob.id
    }

    @commodity.update_column(:activated_at, @fiscal_year.tilikausi_alku)

    generator = CommodityRowGenerator.new(params)

    # 2 rows before generation
    assert_equal 2, FixedAssets::CommodityRow.count

    generator.generate_rows

    # 12 rows after generation
    assert_equal 12, FixedAssets::CommodityRow.count

    generator.mark_rows_obsolete
    assert_equal 0, FixedAssets::CommodityRow.count
  end
end
