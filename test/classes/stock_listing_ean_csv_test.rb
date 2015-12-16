require 'test_helper'

class StockListingEanCsvTest < ActiveSupport::TestCase
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

  # This report is inherited from StockListingCsv, so most of the tests are there
  test 'report output difference' do
    report = StockListingEanCsv.new company_id: @company.id
    output = "EANSKI1,Combosukset,0"
    assert_equal output, report.csv_data.lines.first.chomp

    ean_count = @company.products.active.where.not(eankoodi: '').count
    assert_equal ean_count, report.csv_data.lines.count
  end

  test 'saving report to file with special name' do
    report = StockListingEanCsv.new(company_id: @company.id)
    filename = report.to_file

    # we need to have special filename (NOT UNIQUE BY CUSTOMER REQUEST)
    name = "Varastotilanne #{Date.today.strftime('%d.%m.%Y')}.csv"
    assert_equal name, File.basename(filename)

    # test we can make a file, and the content is same as csv data
    assert File.exists? filename
    assert_equal report.csv_data, File.open(filename, "rb").read

    File.delete filename
  end
end
