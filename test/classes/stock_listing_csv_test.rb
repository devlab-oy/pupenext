require 'test_helper'

class StockListingCsvTest < ActiveSupport::TestCase
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
  end

  test 'report initialize' do
    assert StockListingCsv.new company_id: @company.id
    assert_raises { StockListingCsv.new }
    assert_raises { StockListingCsv.new company_id: nil }
    assert_raises { StockListingCsv.new company_id: -1 }
  end

  test 'report output' do
    product = @company.products.active.first
    product.update! tuoteno: 'A1', eankoodi: 'FOO', nimitys: 'BAR'

    # We should get product info and stock available
    report = StockListingCsv.new(company_id: @company.id)
    output = "A1,FOO,BAR,#{product.stock_available}\n"
    assert_equal output, report.csv_data.lines.first

    # if stock is negative, we should get zero for stock
    product.shelf_locations.update_all(saldo: -10)
    report = StockListingCsv.new(company_id: @company.id)
    output = "A1,FOO,BAR,0.0\n"
    assert_equal output, report.csv_data.lines.first
  end

  test 'saving report to file' do
    report = StockListingCsv.new(company_id: @company.id)
    filename = 'kissa.csv'

    # test we can make a file, and the content is same as csv data
    assert report.csv_file filename
    assert File.exists? filename
    assert_equal report.csv_data, File.open(filename, "rb").read

    File.delete filename
  end
end
