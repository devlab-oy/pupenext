require 'test_helper'

class Reports::CommodityTest < ActiveSupport::TestCase
  fixtures %w(
    accounts
    fiscal_years
    fixed_assets/commodities
    fixed_assets/commodity_rows
    head/voucher_rows
    heads
    qualifiers
    sum_levels
  )

  setup do
    @acme = companies :acme

    @report = Reports::Commodity.new(
      company_id: @acme.id,
      start_date: Date.today.beginning_of_year.to_s,
      end_date:   Date.today.end_of_year,
    )
  end

  test 'class' do
    assert_not_nil @report
  end

  test 'required relations' do
    assert @acme.sum_level_commodities.count > 0
  end

  test 'returns response hierarcy' do
    data = @report.data
    assert_equal Reports::Commodity::Response, data.class
    assert_equal "0.0", data.deprication_total.to_s
    assert_equal "111.0", data.difference_total.to_s
    assert_equal "1001.0", data.btl_total.to_s
    assert_equal "10000.0", data.procurement_amount_total.to_s
    assert_equal "0.0", data.opening_deprication_total.to_s
    assert_equal "0.0", data.closing_deprication_total.to_s
    assert_equal "0.0", data.opening_btl_total.to_s
    assert_equal "1001.0", data.closing_btl_total.to_s
    assert_equal "0.0", data.opening_difference_total.to_s
    assert_equal "111.0", data.closing_difference_total.to_s
    assert_equal "10000.0", data.opening_bookkeeping_value.to_s
    assert_equal "10000.0", data.closing_bookkeeping_value.to_s
    assert_equal "10000.0", data.opening_btl_value.to_s
    assert_equal "11001.0", data.closing_btl_value.to_s

    sum_levels = data.sum_levels
    assert_equal Array, sum_levels.class

    sum_level = sum_levels.first
    assert_equal Reports::Commodity::SumLevel, sum_level.class
    assert_equal "112 - TILIKAUDEN TULOS112", sum_level.name
    assert_equal "0.0", sum_level.deprication_total.to_s
    assert_equal "111.0", sum_level.difference_total.to_s
    assert_equal "1001.0", sum_level.btl_total.to_s
    assert_equal "10000.0", sum_level.procurement_amount_total.to_s
    assert_equal "0.0", sum_level.opening_deprication_total.to_s
    assert_equal "0.0", sum_level.closing_deprication_total.to_s
    assert_equal "0.0", sum_level.opening_btl_total.to_s
    assert_equal "1001.0", sum_level.closing_btl_total.to_s
    assert_equal "0.0", sum_level.opening_difference_total.to_s
    assert_equal "111.0", sum_level.closing_difference_total.to_s
    assert_equal "10000.0", sum_level.opening_bookkeeping_value.to_s
    assert_equal "10000.0", sum_level.closing_bookkeeping_value.to_s
    assert_equal "10000.0", sum_level.opening_btl_value.to_s
    assert_equal "11001.0", sum_level.closing_btl_value.to_s

    accounts = sum_level.accounts
    assert_equal Array, accounts.class

    account = accounts.first
    assert_equal Reports::Commodity::Account, account.class
    assert_equal "4444 - EVL poistoerovastatili", account.name
    assert_equal "0.0", account.deprication_total.to_s
    assert_equal "111.0", account.difference_total.to_s
    assert_equal "1001.0", account.btl_total.to_s
    assert_equal "10000.0", account.procurement_amount_total.to_s
    assert_equal "0.0", account.opening_deprication_total.to_s
    assert_equal "0.0", account.closing_deprication_total.to_s
    assert_equal "0.0", account.opening_btl_total.to_s
    assert_equal "1001.0", account.closing_btl_total.to_s
    assert_equal "0.0", account.opening_difference_total.to_s
    assert_equal "111.0", account.closing_difference_total.to_s
    assert_equal "10000.0", account.opening_bookkeeping_value.to_s
    assert_equal "10000.0", account.closing_bookkeeping_value.to_s
    assert_equal "10000.0", account.opening_btl_value.to_s
    assert_equal "11001.0", account.closing_btl_value.to_s

    commodities = account.commodities
    assert_equal Array, commodities.class

    commodity = commodities.first
    assert_equal Reports::Commodity::Commodity, commodity.class
    assert_equal "This is a commodity!", commodity.name
    assert_equal "0.0", commodity.deprication.to_s
    assert_equal "111.0", commodity.difference.to_s
    assert_equal "1001.0", commodity.btl.to_s
    assert_equal "10000.0", commodity.procurement_amount.to_s
    assert_equal "0.0", commodity.opening_deprication.to_s
    assert_equal "0.0", commodity.closing_deprication.to_s
    assert_equal "0.0", commodity.opening_btl.to_s
    assert_equal "1001.0", commodity.closing_btl.to_s
    assert_equal "0.0", commodity.opening_difference.to_s
    assert_equal "111.0", commodity.closing_difference.to_s
    assert_equal commodity.commodity.activated_at, commodity.procurement_date
    assert_equal "10000.0", commodity.opening_bookkeeping_value.to_s
    assert_equal "10000.0", commodity.closing_bookkeeping_value.to_s
    assert_equal "10000.0", commodity.opening_btl_value.to_s
    assert_equal "11001.0", commodity.closing_btl_value.to_s
  end
end
