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
    shelf_locations(:two).delete

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
    today = Time.zone.today
    week = Week.new(today).human
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
    report = StockAvailability.new(company_id: @company.id, baseline_week: 4, constraints: {})

    assert_equal 'hammer123',         report.to_screen.first.sku
    assert_equal 'All-around hammer', report.to_screen.first.label
    assert_equal 330,                 report.to_screen.first.initial_stock

    # Historia ja upcoming
    assert_equal 15,  report.to_screen.first.overdue.sales
    assert_equal 12,  report.to_screen.first.overdue.purchases
    assert_equal 327, report.to_screen.first.overdue.change

    assert_equal 14,  report.to_screen.first.upcoming.sales
    assert_equal 55,  report.to_screen.first.upcoming.purchases
    assert_equal 364, report.to_screen.first.upcoming.change

    # Viikkokohtainen data
    firstweek = report.to_screen.first.weekly_data.first
    assert_equal week, firstweek.week
    assert_equal 7,    firstweek.stock_values.amount_sold
    assert_equal 3,    firstweek.stock_values.amount_purchased
    assert_equal 323,  firstweek.stock_values.total_stock_change
    assert_equal 1,    firstweek.stock_values.order_numbers.count

    # Yhteensä-sarake
    total = report.to_screen.first
    assert_equal 364, total.total_stock
    assert_equal 36,  total.total_amount_sold
    assert_equal 70,  total.total_amount_purchased
  end
end
