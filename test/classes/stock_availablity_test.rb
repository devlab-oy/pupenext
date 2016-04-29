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
    # Tests assume that hammer is the first product so huutokauppa_delivery_93 has to be deleted
    products(:huutokauppa_delivery_93).delete

    @company = companies :acme
    @sales_order = sales_order_orders :so_one
    @purchase_order = purchase_order_orders :po_one
  end

  test 'report initialize' do
    const = {
      category: [],
      subcategory: [],
      brand: []
    }
    assert StockAvailability.new company_id: @company.id, baseline_week: 16, constraints: const
    assert_raises { StockAvailability.new }
    assert_raises { StockAvailability.new company_id: nil }
    assert_raises { StockAvailability.new company_id: -1 }
    assert_raises { StockAvailability.new company_id: @company.id, weeks: nil }
    assert_raises { StockAvailability.new company_id: @company.id, weeks: 'kissa', constraints: nil }
  end

  test 'report output' do
    TestObject = Struct.new(:sku, :label, :initial_stock, :overdue, :upcoming, :weekly_data, :total_stock, :total_amount_sold, :total_amount_purchased)
    TestWeekObject = Struct.new(:week, :stock_values)
    TestStockObject = Struct.new(:amount_sold, :amount_purchased, :total_stock_change, :order_numbers)
    TestAmounts = Struct.new(:sales, :purchases, :change)

    today = Date.today
    shelf = @company.shelf_locations.first
    product = Product.find_by_tuoteno shelf.tuoteno
    product.shelf_locations.first.update!(saldo: 330)

    # Create past, now and future rows in purchase and sales orders
    # Past
    newporow = @purchase_order.rows.first.dup
    newporow.update_attributes! toimaika: today.advance(days: -10), varattu: 12, laskutettuaika: 0

    newsorow = @sales_order.rows.first.dup
    newsorow.update_attributes! toimaika: today.advance(days: -10), varattu: 15, laskutettuaika: 0

    # Now
    newporow = @purchase_order.rows.first.dup
    newporow.update_attributes! toimaika: today, varattu: 3, laskutettuaika: 0

    newsorow = @sales_order.rows.first.dup
    newsorow.update_attributes! toimaika: today, varattu: 7, laskutettuaika: 0

    # Future
    newporow = @purchase_order.rows.first.dup
    newporow.update_attributes! toimaika: today.advance(weeks: 10), varattu: 55, laskutettuaika: 0

    newsorow = @sales_order.rows.first.dup
    newsorow.update_attributes! toimaika: today.advance(weeks: 10), varattu: 14, laskutettuaika: 0

    # We should get product info and stock available 10
    # undelivered_amount from past 12, upcoming_amount after the baseline
    # plus 4 weeks worth of sold and purchased amounts
    const = {
      category: [],
      subcategory: [],
      brand: []
    }
    report = StockAvailability.new(company_id: @company.id, baseline_week: 4, constraints: const)

    order_numbers0 = [newsorow.otunnus]

    stock0 = TestStockObject.new(7.0, 3.0, 323.0, order_numbers0)
    stock1 = TestStockObject.new(0.0, 0.0, 323.0)
    stock2 = TestStockObject.new(0.0, 0.0, 323.0)
    stock3 = TestStockObject.new(0.0, 0.0, 323.0)
    stock4 = TestStockObject.new(0.0, 0.0, 323.0)

    week0 = TestWeekObject.new("#{today.cweek} / #{today.year}", stock0)
    week1 = TestWeekObject.new("#{today.cweek+1} / #{today.year}", stock1)
    week2 = TestWeekObject.new("#{today.cweek+2} / #{today.year}", stock2)
    week3 = TestWeekObject.new("#{today.cweek+3} / #{today.year}", stock3)
    week4 = TestWeekObject.new("#{today.cweek+4} / #{today.year}", stock4)

    history_amounts = TestAmounts.new(15.0, 12.0, 327.0)
    future_amounts  = TestAmounts.new(14.0, 55.0, 364.0)

    testo = TestObject.new("hammer123", "All-around hammer", 330.0, history_amounts, future_amounts,
      [
        [week0.week, week0.stock_values],
        [week1.week, week1.stock_values],
        [week2.week, week2.stock_values],
        [week3.week, week3.stock_values],
        [week4.week, week4.stock_values]
      ],
      364.0,
      36.0,
      70.0
    )

    assert_equal report.to_screen.first.sku, testo.sku
    assert_equal report.to_screen.first.label, testo.label
    assert_equal report.to_screen.first.initial_stock, testo.initial_stock

    # Historia ja upcoming
    assert_equal report.to_screen.first.overdue.sales, testo.overdue.sales
    assert_equal report.to_screen.first.overdue.purchases, testo.overdue.purchases
    assert_equal report.to_screen.first.overdue.change, testo.overdue.change

    assert_equal report.to_screen.first.upcoming.sales, testo.upcoming.sales
    assert_equal report.to_screen.first.upcoming.purchases, testo.upcoming.purchases
    assert_equal report.to_screen.first.upcoming.change, testo.upcoming.change

    # Viikkokohtainen data
    firstweek = report.to_screen.first.weekly_data.first
    assert_equal firstweek.week, week0.week
    assert_equal firstweek.stock_values.amount_sold, week0.stock_values.amount_sold
    assert_equal firstweek.stock_values.amount_purchased, week0.stock_values.amount_purchased
    assert_equal firstweek.stock_values.total_stock_change, week0.stock_values.total_stock_change
    assert_equal firstweek.stock_values.order_numbers, week0.stock_values.order_numbers

    # Yhteensä-sarake
    assert_equal report.to_screen.first.total_stock, testo.total_stock
    assert_equal report.to_screen.first.total_amount_sold, testo.total_amount_sold
    assert_equal report.to_screen.first.total_amount_purchased, testo.total_amount_purchased
  end
end
