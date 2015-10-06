require 'test_helper'

class StockAvailabilityTest < ActiveSupport::TestCase
  fixtures %w(
    products
    purchase_order/orders
    purchase_order/rows
    sales_order/orders
    sales_order/rows
    shelf_locations
  )

  setup do
    @company = companies :acme
    @sales_order = sales_order_orders :so_one
    @purchase_order = purchase_order_orders :po_one
  end

  test 'report initialize' do
    assert StockAvailability.new company_id: @company.id, baseline_week: 16
    assert_raises { StockAvailability.new }
    assert_raises { StockAvailability.new company_id: nil }
    assert_raises { StockAvailability.new company_id: -1 }
    assert_raises { StockAvailability.new company_id: @company.id, weeks: 'kissa'}
    assert_raises { StockAvailability.new company_id: @company.id, weeks: [13, 14]}
  end

  test 'report diibadaaba' do
    stocks = StockAvailability.new company_id: @company.id, baseline_week: 16
    assert_equal 'kissa', stocks.to_screen
  end

  test 'report output' do
    shelf = @company.shelf_locations.first
    product = Product.find_by_tuoteno shelf.tuoteno
    product.shelf_locations.update_all(saldo: 13)
    product.shelf_locations.first.update!(tuoteno: 'A1', saldo: 10)
    product.update! tuoteno: 'A1', eankoodi: 'FOO', nimitys: 'BAR'

    # We should get product info and stock available 10
    # undelivered_amount, upcoming_amount
    # plus 4 weeks worth of sold and purchased amounts
    report = StockAvailability.new(company_id: @company.id, baseline_week: 4)
    data = ["A1", "BAR", "10.0", [
      ["41 / 2015", ["0.0", "0.0"]],
      ["42 / 2015", ["0.0", "0.0"]],
      ["43 / 2015", ["0.0", "0.0"]],
      ["44 / 2015", ["0.0", "0.0"]],
      ["45 / 2015", ["0.0", "0.0"]]
    ]]
    assert_equal report.to_screen[1], data

    # If stock is negative we should get zero stock
    #product.shelf_locations.first.update!(tuoteno: 'A1', saldo: -10)
    #report = StockAvailability.new(company_id: @company.id, baseline_week: 16)
    #assert_equal 'kissa', report.to_screen[1]
    #assert report.to_screen.include? 'kissa'
    #assert_equal -10, product.stock

    # if we have upcoming orders, we should get the date and stock after
    #@purchase_order.rows.first.update!(
    #  tuoteno: product.tuoteno,
    #  toimaika: '2015-01-01',
    #  varattu: 20,
    #  laskutettuaika: 0
    #)
    #report = StockAvailability.new(company_id: @company.id, baseline_week: 16)
    #assert report.to_screen
  end

end
