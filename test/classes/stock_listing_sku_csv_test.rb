require 'test_helper'

class StockListingSkuCsvTest < ActiveSupport::TestCase
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
    report = StockListingSkuCsv.new company_id: @company.id
    output = 'z3335,Paita 5,0'
    assert_equal output, report.csv_data.lines.first.chomp
  end
end
