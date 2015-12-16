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
end
