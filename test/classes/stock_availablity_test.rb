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
    shelf = @company.shelf_locations.first
    product = Product.find_by_tuoteno shelf.tuoteno
    product.shelf_locations.first.update!(saldo: 330)

    # Create past, now and future rows in purchase and sales orders
    # Past
    newporow = @purchase_order.rows.first.dup
    newporow.assign_attributes({ toimaika:  Date.today.advance(days: -10), varattu: 12, laskutettuaika: 0 })
    newporow.save!

    newsorow = @sales_order.rows.first.dup
    newsorow.assign_attributes({ toimaika:  Date.today.advance(days: -10), varattu: 15, laskutettuaika: 0 })
    newsorow.save!

    # Now
    newporow = @purchase_order.rows.first.dup
    newporow.assign_attributes({ toimaika: Date.today, varattu: 3, laskutettuaika: 0 })
    newporow.save!

    newsorow = @sales_order.rows.first.dup
    newsorow.assign_attributes({ toimaika:  Date.today, varattu: 7, laskutettuaika: 0 })
    newsorow.save!

    # Future
    newporow = @purchase_order.rows.first.dup
    newporow.assign_attributes({ toimaika:  Date.today.advance(weeks: 10), varattu: 55, laskutettuaika: 0 })
    newporow.save!

    newsorow = @sales_order.rows.first.dup
    newsorow.assign_attributes({ toimaika:  Date.today.advance(weeks: 10), varattu: 14, laskutettuaika: 0 })
    newsorow.save!

    # We should get product info and stock available 10
    # undelivered_amount from past 12, upcoming_amount after the baseline
    # plus 4 weeks worth of sold and purchased amounts
    const = {
      category: [],
      subcategory: [],
      brand: []
    }
    report = StockAvailability.new(company_id: @company.id, baseline_week: 4, constraints: const)

    TestObject = Struct.new(:tuoteno, :nimitys, :saldo, :myohassa,
      :tulevat, :viikkodata, :loppusaldo)

    today = Date.today
    testo = TestObject.new("hammer123", "All-around hammer", 330.0, [15.0, 12.0, 327.0], [14.0, 55.0, 364.0],
      [
        ["#{today.cweek} / #{today.year}", [7.0, 3.0, 323.0]],
        ["#{today.cweek+1} / #{today.year}", [0.0, 0.0, 323.0]],
        ["#{today.cweek+2} / #{today.year}", [0.0, 0.0, 323.0]],
        ["#{today.cweek+3} / #{today.year}", [0.0, 0.0, 323.0]],
        ["#{today.cweek+4} / #{today.year}", [0.0, 0.0, 323.0]]
      ],
      364.0
    )

    assert_equal report.to_screen.first.tuoteno, testo.tuoteno
    assert_equal report.to_screen.first.nimitys, testo.nimitys
    assert_equal report.to_screen.first.saldo, testo.saldo
    assert_equal report.to_screen.first.myohassa, testo.myohassa
    assert_equal report.to_screen.first.tulevat, testo.tulevat
    assert_equal report.to_screen.first.viikkodata, testo.viikkodata
    assert_equal report.to_screen.first.loppusaldo, testo.loppusaldo
  end

end
