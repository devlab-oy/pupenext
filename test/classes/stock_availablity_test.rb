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
    @purchase_order = purchase_order_orders :po_two
  end

  test 'report initialize' do
    assert StockAvailability.new company_id: @company.id, baseline_week: 16
    assert_raises { StockAvailability.new }
    assert_raises { StockAvailability.new company_id: nil }
    assert_raises { StockAvailability.new company_id: -1 }
    assert_raises { StockAvailability.new company_id: @company.id, weeks: nil }
    assert_raises { StockAvailability.new company_id: @company.id, weeks: 'kissa' }
  end

  test 'report output' do
    shelf = @company.shelf_locations.first
    product = Product.find_by_tuoteno shelf.tuoteno
    product.shelf_locations.first.update!(saldo: 10)

    # Create past, future and current rows in purchase and sales orders


    # We should get product info and stock available 10
    # undelivered_amount from past 12, upcoming_amount after the baseline
    # plus 4 weeks worth of sold and purchased amounts
    report = StockAvailability.new(company_id: @company.id, baseline_week: 4)

    TestObject = Struct.new(:tuoteno, :nimitys, :saldo, :myohassa,
      :tulevat, :viikkodata)

    testo = TestObject.new("hammer123", "All-around hammer", 10.0, [0.0, 12.0], [0.0, 55.0],
      [
        ["41 / 2015", ["3.0", "0.0"]],
        ["42 / 2015", ["0.0", "0.0"]],
        ["43 / 2015", ["0.0", "0.0"]],
        ["44 / 2015", ["0.0", "0.0"]],
        ["45 / 2015", ["0.0", "0.0"]]
    ])

    assert_equal report.to_screen.second.tuoteno, testo.tuoteno
    assert_equal report.to_screen.second.nimitys, testo.nimitys
    assert_equal report.to_screen.second.saldo, testo.saldo
    assert_equal report.to_screen.second.myohassa, testo.myohassa
    assert_equal report.to_screen.second.tulevat, testo.tulevat
    assert_equal report.to_screen.second.viikkodata, testo.viikkodata
  end

end
