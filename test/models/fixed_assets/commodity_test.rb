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
    @company = @commodity.company

    Current.user = users :bob
  end

  teardown do
    # make sure other tests don't mess up our dates
    travel_back
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

  test 'linkable invoice rows' do
    assert_equal 1, @commodity.linkable_invoice_rows.count
    purchase_invoice_paid = Head.find(@commodity.linkable_invoice_rows.first.ltunnus)
    assert_equal purchase_invoice_paid.tila, 'Y'
  end

  test 'linkable voucher rows' do
    assert_equal 2, @commodity.linkable_voucher_rows.count
    voucher = Head.find(@commodity.linkable_voucher_rows.first.ltunnus)
    assert_equal voucher.tila, 'X'
  end

  test 'current bookkeeping value works' do
    # dates
    year_beginning = Date.today.beginning_of_year
    year_end = Date.today.end_of_year
    september = Date.today.change(month: 9, day: 1)

    # travel to September, we cannot sell a commodity in the past
    # make today September, sell in October
    travel_to september

    # set open period to full year
    @company.update!(
      tilikausi_alku: year_beginning,
      tilikausi_loppu: year_end,
    )

    Current.company = @company

    # activate commodity
    @commodity.update! activated_at: year_beginning
    assert @commodity.activate
    assert @commodity.generate_rows

    assert_equal "7647.04", @commodity.bookkeeping_value(september).to_s
    assert_equal "6500.0", @commodity.bookkeeping_value(year_end).to_s

    @commodity.update!(
      amount_sold: @commodity.amount,
      deactivated_at: september,
      profit_account: accounts(:account_100),
      sales_account: accounts(:account_110),
      depreciation_remainder_handling: 'S',
    )

    # travel to October, sell date must be in the future
    travel_to Date.today.change(month: 10, day: 1)

    assert @commodity.can_be_sold?, @commodity.errors.full_messages
    assert @commodity.valid?, @commodity.errors.full_messages

    assert @commodity.sell

    # Sold commodity bookkeeping value should be 0
    assert_equal 'P', @commodity.status
    assert_equal 0, @commodity.bookkeeping_value(year_end).to_s
  end

  test 'current btl value works with or without history amount' do
    # EVL arvo tilikauden lopussa
    @commodity.status = 'A'
    @commodity.generate_rows

    assert_equal 6000.0, @commodity.btl_value(@commodity.company.current_fiscal_year.last)

    # Toisesta järjestelmästä perityt poistot
    @commodity.previous_btl_depreciations = 5000.0
    @commodity.save!
    @commodity.generate_rows

    assert_equal 3000.0, @commodity.btl_value(@commodity.company.current_fiscal_year.last)
  end

  test 'cant be sold with invalid params' do
    refute @commodity.can_be_sold?, 'Should not be valid because no depreciations'
    validparams = {
      amount_sold: 9800,
      deactivated_at: Date.today,
      profit_account: accounts(:account_100),
      sales_account: accounts(:account_110),
      depreciation_remainder_handling: 'S'
    }
    @commodity.attributes = validparams
    @commodity.save!
    @commodity.generate_rows

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

  test 'accumulated depreciation and bookkeeping method uses transferred_procurement_amount' do
    activation_bookkeeping_value = 10000.0

    # If rows present, values should not be affected by transferred procurement amount
    @commodity.generate_rows
    assert_equal 1200.0, @commodity.accumulated_depreciation_at(Date.today)
    assert_equal 8800.0, @commodity.bookkeeping_value(Date.today)
    assert_equal activation_bookkeeping_value, @commodity.amount

    transferred_amount = 20000.0
    @commodity.transferred_procurement_amount = transferred_amount
    assert_equal 1200.0, @commodity.accumulated_depreciation_at(Date.today).to_s
    assert_equal 8800.0, @commodity.bookkeeping_value(Date.today)

    # If rows not present, values should be affected by transferred procurement amount
    @commodity.delete_rows
    @commodity.transferred_procurement_amount = 0.0
    assert_equal 0.0, @commodity.accumulated_depreciation_at(Date.today)
    assert_equal activation_bookkeeping_value, @commodity.bookkeeping_value(Date.today)

    @commodity.transferred_procurement_amount = transferred_amount
    assert_equal transferred_amount, @commodity.accumulated_depreciation_at(Date.today)
    assert_equal 0.0, @commodity.bookkeeping_value(Date.today)

    # If procurement rows linked and amount still 0 and transferred > 0
    hankintahintarivi = head_voucher_rows(:six)
    hankintahintarivi.summa = 0.0
    hankintahintarivi.save!
    @commodity.transferred_procurement_amount = 26190.0
    @commodity.save!
    @commodity.generate_rows

    assert_equal 0.0, @commodity.bookkeeping_value(Date.today)
    assert_equal 26190.0, @commodity.accumulated_depreciation_at(Date.today)
    assert_equal 0, @commodity.depreciation_rows.count
  end

  test 'test adding a volkswagen from an old system' do
    # account for procurements
    account = accounts :account_commodity

    # dates
    year_beginning = Date.today.beginning_of_year
    year_end = Date.today.end_of_year

    # set open period
    @company.update!(
      tilikausi_alku: year_beginning,
      tilikausi_loppu: year_end,
    )

    Current.company = @company

    # create commodity (values from old system)
    commodity = @company.commodities.create!(
      name: "Volkswagen Golf Variant",
      description: "Economa 661",
      planned_depreciation_type: "T",
      planned_depreciation_amount: 48,
      btl_depreciation_type: "B",
      btl_depreciation_amount: 25,
      previous_btl_depreciations: 4661.25,
      transferred_procurement_amount: 26190.0,
      activated_at: year_beginning
    )

    # add procurement voucher for zero
    commodity.procurement_rows.create!(
      tilino: account.tilino,
      tapvm: year_beginning,
      summa: 0,
      selite: "VW alkusaldot 1.1. sumu 0 evl 4661,25"
    )

    assert commodity.activate
    assert commodity.activated?
    assert commodity.generate_rows

    # alkuperäinen hankintahinta (vanhasta järjestelmästä)
    assert_equal "26190.0", commodity.procurement_amount.to_s

    # SUMU -puoli

    # 1. kirjanpidollinen SUMU arvo (menojäännös) vuoden alussa (kaikki on jo poistettu vanhassa järjestelmässä)
    assert_equal "0.0", commodity.bookkeeping_value(year_beginning).to_s

    # 2. Kertyneet SUMU -poistot vuoden alussa (kaikki on jo poistettu vanhassa järjestelmässä)
    assert_equal "26190.0", commodity.accumulated_depreciation_at(year_beginning).to_s

    # 3. SUMU -poistoja vuoden aikana (ei mitään poistettavaa tässä järjestelmässä)
    assert_equal "0.0", commodity.depreciation_between(year_beginning, year_end).to_s

    # 4. Kertyneet SUMU -poistot vuoden lopussa (kaikki poistettu)
    assert_equal "26190.0", commodity.accumulated_depreciation_at(year_end).to_s

    # 5. kirjanpidollinen SUMU arvo (menojäännös) vuoden lopussa
    assert_equal "0.0", commodity.bookkeeping_value(year_end).to_s

    # EVL -puoli

    # 1. EVL-arvo (menojäännös) vuoden alussa (siirretty vanhasta järjestelmästä)
    assert_equal "4661.25", commodity.btl_value(year_beginning).to_s

    # 2. kertyneet EVL-poistot vuoden alussa (poistettu vanhassa järjestelmässä)
    assert_equal "21528.75", commodity.accumulated_evl_at(year_beginning).to_s

    # 3. EVL -poistoja vuoden aikana (poistettu meidän järjestelmässä)
    assert_equal "1165.31", commodity.evl_between(year_beginning, year_end).to_s

    # 4. kertyneet EVL-poistot vuoden lopussa
    assert_equal "22694.06", commodity.accumulated_evl_at(year_end).to_s

    # 5. EVL-arvo (menojäännös) vuoden lopussa
    assert_equal "3495.94", commodity.btl_value(year_end).to_s

    # POISTOEROT

    # kertyneet poistoerot vuoden alussa
    assert_equal "4661.25", commodity.accumulated_difference_at(year_beginning).to_s

    # kertyneet poistoerot vuoden aikana
    assert_equal "1165.31", commodity.difference_between(year_beginning, year_end).to_s

    # kertyneet poistoerot vuoden lopussa
    assert_equal "3495.94", commodity.accumulated_difference_at(year_end).to_s
  end

  test 'buying a honda in our system' do
    # account for procurements
    account = accounts :account_commodity

    # dates
    year_beginning = Date.today.beginning_of_year
    year_end = Date.today.end_of_year
    year_feb = Date.today.change(month: 2, day: 3)

    # set open period
    @company.update!(
      tilikausi_alku: year_beginning,
      tilikausi_loppu: year_end,
    )

    Current.company = @company

    # create commodity (values from old system)
    commodity = @company.commodities.create!(
      name: "Honda CR-V",
      description: "Sininen",
      planned_depreciation_type: "T",
      planned_depreciation_amount: 60,
      btl_depreciation_type: "B",
      btl_depreciation_amount: 25,
      activated_at: year_feb
    )

    # add procurement voucher for zero
    commodity.procurement_rows.create!(
      tilino: account.tilino,
      tapvm: year_feb,
      summa: 49716.55,
      selite: "Honda CR-V"
    )

    assert commodity.activate
    assert commodity.activated?
    assert commodity.generate_rows

    # alkuperäinen hankintahinta
    assert_equal "49716.55", commodity.procurement_amount.to_s

    # SUMU -puoli

    # 1. kirjanpidollinen SUMU arvo (menojäännös) vuoden alussa
    assert_equal "0.0", commodity.bookkeeping_value(year_beginning).to_s

    # 1.1 kirjanpidollinen SUMU arvo (menojäännös) päivää ennen aktivointia
    assert_equal "0.0", commodity.bookkeeping_value(year_feb - 1.day).to_s

    # 1.2 kirjanpidollinen SUMU arvo (menojäännös) aktivointipäivänä
    assert_equal "49716.55", commodity.bookkeeping_value(year_feb).to_s

    # 2. Kertyneet SUMU -poistot vuoden alussa
    assert_equal "0.0", commodity.accumulated_depreciation_at(year_beginning).to_s

    # 3. SUMU -poistoja vuoden aikana
    assert_equal "9114.7", commodity.depreciation_between(year_beginning, year_end).to_s

    # 4. Kertyneet SUMU -poistot vuoden lopussa
    assert_equal "9114.7", commodity.accumulated_depreciation_at(year_end).to_s

    # 5. kirjanpidollinen SUMU arvo (menojäännös) vuoden lopussa
    assert_equal "40601.85", commodity.bookkeeping_value(year_end).to_s

    # EVL -puoli

    # 1. EVL-arvo (menojäännös) vuoden alussa
    assert_equal "0.0", commodity.btl_value(year_beginning).to_s

    # 1.1 EVL-arvo (menojäännös) päivää ennen aktivointia
    assert_equal "0.0", commodity.btl_value(year_feb - 1.day).to_s

    # 1.2 EVL-arvo (menojäännös) aktivointipäivänä
    assert_equal "49716.55", commodity.btl_value(year_feb).to_s

    # 2. kertyneet EVL-poistot vuoden alussa
    assert_equal "-0.0", commodity.accumulated_evl_at(year_beginning).to_s

    # 3. EVL -poistoja vuoden aikana
    assert_equal "12429.14", commodity.evl_between(year_beginning, year_end).to_s

    # 4. kertyneet EVL-poistot vuoden lopussa
    assert_equal "12429.14", commodity.accumulated_evl_at(year_end).to_s

    # 5. EVL-arvo (menojäännös) vuoden lopussa
    assert_equal "37287.41", commodity.btl_value(year_end).to_s

    # POISTOEROT

    # kertyneet poistoerot vuoden alussa
    assert_equal "0.0", commodity.accumulated_difference_at(year_beginning).to_s

    # kertyneet poistoerot vuoden aikana
    assert_equal "-3314.44", commodity.difference_between(year_beginning, year_end).to_s

    # kertyneet poistoerot vuoden lopussa
    assert_equal "-3314.44", commodity.accumulated_difference_at(year_end).to_s
  end
end
