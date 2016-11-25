require 'test_helper'

class StockListingCsvTest < ActiveSupport::TestCase
  fixtures %w(
    products
    purchase_order/orders
    purchase_order/rows
    sales_order/orders
    sales_order/rows
    shelf_locations
    warehouses
  )

  setup do
    # Tests assume that hammer is the first product so huutokauppa_delivery_93 has to be deleted
    products(:huutokauppa_delivery_93).delete

    @company = companies :acme
    @purchase_order = purchase_order_orders :po_one
  end

  test 'report initialize' do
    assert StockListingCsv.new company_id: @company.id
    assert_raises { StockListingCsv.new }
    assert_raises { StockListingCsv.new company_id: nil }
    assert_raises { StockListingCsv.new company_id: -1 }
  end

  test 'report output' do
    shelf = @company.shelf_locations.first
    product = Product.find_by_tuoteno shelf.tuoteno
    product.shelf_locations.update_all(saldo: 0)
    product.shelf_locations.first.update!(tuoteno: 'A1', saldo: 10)
    product.update! tuoteno: 'A1', eankoodi: 'FOO', nimitys: 'BAR'

    # We should get product info and stock available 10
    report = StockListingCsv.new(company_id: @company.id)
    output = "A1,FOO,BAR,10,,\n"
    assert report.csv_data.lines.include? output

    # If stock is negative we should get zero stock
    product.shelf_locations.first.update!(tuoteno: 'A1', saldo: -10)
    report = StockListingCsv.new(company_id: @company.id)
    output = "A1,FOO,BAR,0,,\n"
    assert report.csv_data.lines.include? output
    assert_equal -10, product.stock

    # if we have upcoming orders, we should get the date and stock after
    @purchase_order.rows.first.update!(
      tuoteno: product.tuoteno,
      toimaika: '2015-01-01',
      varattu: 20,
      laskutettuaika: 0
    )
    report = StockListingCsv.new(company_id: @company.id)
    output = "A1,FOO,BAR,0,2015-01-01,10\n"
    assert report.csv_data.lines.include? output
    assert File.open(report.to_file, "rb").read.include? output

    report = StockListingCsv.new(company_id: @company.id, column_separator: '|')
    output = "A1|FOO|BAR|0|2015-01-01|10\n"
    assert report.csv_data.lines.include? output
    assert File.open(report.to_file, "rb").read.include? output

    report = StockListingCsv.new(company_id: @company.id, column_separator: ';')
    output = "A1;FOO;BAR;0;2015-01-01;10\n"
    assert report.csv_data.lines.include? output
    assert File.open(report.to_file, "rb").read.include? output
  end

  test 'saving report to file' do
    report = StockListingCsv.new(company_id: @company.id)
    filename = report.to_file

    # test we can make a file, and the content is same as csv data
    assert File.exists? filename
    assert_equal report.csv_data, File.open(filename, "rb").read

    File.delete filename
  end

  test 'pass in warehouse ids' do
    veikkola = warehouses :veikkola
    kontula  = warehouses :kontula
    warehouse_ids = [veikkola.id, kontula.id]

    # hammer should be in veikkola and kontula, update stock to 10 in both
    hammer = products :hammer
    hammer.shelf_locations.where.not(varasto: warehouse_ids).delete_all
    hammer.shelf_locations.update_all(saldo: 10)

    # we should have 20 stock
    report = StockListingCsv.new(company_id: @company.id)
    output = "hammer123,EANHAMMER123,All-around hammer,20,,\n"
    assert report.csv_data.lines.include?(output), report.csv_data.lines

    # pass warehouses as a string
    report = StockListingCsv.new(company_id: @company.id, warehouse_ids: warehouse_ids.join(','))
    output = "hammer123,EANHAMMER123,All-around hammer,20,,\n"
    assert report.csv_data.lines.include?(output), report.csv_data.lines

    # pass warehouses as an array
    report = StockListingCsv.new(company_id: @company.id, warehouse_ids: warehouse_ids)
    output = "hammer123,EANHAMMER123,All-around hammer,20,,\n"
    assert report.csv_data.lines.include?(output), report.csv_data.lines

    # pass warehouses as an empty string
    report = StockListingCsv.new(company_id: @company.id, warehouse_ids: "")
    output = "hammer123,EANHAMMER123,All-around hammer,20,,\n"
    assert report.csv_data.lines.include?(output), report.csv_data.lines

    # only veikkola should have 10
    report = StockListingCsv.new(company_id: @company.id, warehouse_ids: veikkola.id)
    output = "hammer123,EANHAMMER123,All-around hammer,10,,\n"
    assert report.csv_data.lines.include?(output), report.csv_data.lines
  end
end
