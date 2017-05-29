require 'test_helper'

class StockListingConfigurableCsvTest < ActiveSupport::TestCase
  fixtures %w[
    products
    purchase_order/orders
    purchase_order/rows
    sales_order/orders
    sales_order/rows
    shelf_locations
    warehouses
  ]

  setup do
    @company = companies :acme
    @purchase_order = purchase_order_orders :po_one
  end

  test 'report output when one brand to be included' do
    Keyword::StockListingFilter.create!(selite: 'tuotemerkki', selitetark: 'on', selitetark_2: 'Bosch')
    report = StockListingConfigurableCsv.new(company_id: @company.id)

    assert_equal 1, report.csv_data.lines.count
  end

  test 'report output when two brands to be included' do
    Keyword::StockListingFilter.create!(selite: 'tuotemerkki', selitetark: 'on', selitetark_2: 'Bosch')
    Keyword::StockListingFilter.create!(selite: 'tuotemerkki', selitetark: 'on', selitetark_2: 'Alpinestars')
    report = StockListingConfigurableCsv.new(company_id: @company.id)

    assert_equal 2, report.csv_data.lines.count
  end

  test 'report output when one brand to be excluded' do
    Keyword::StockListingFilter.create!(selite: 'tuotemerkki', selitetark: 'off', selitetark_2: 'Bosch')
    report = StockListingConfigurableCsv.new(company_id: @company.id)

    assert_equal 2, report.csv_data.lines.count
  end

  test 'report output when one subcategory to be included' do
    Keyword::StockListingFilter.create!(selite: 'try', selitetark: 'on', selitetark_2: '2000')
    report = StockListingConfigurableCsv.new(company_id: @company.id)

    assert_equal 2, report.csv_data.lines.count
  end

  test 'report output when one subcategory to be excluded' do
    Keyword::StockListingFilter.create!(selite: 'try', selitetark: 'off', selitetark_2: '2000')
    report = StockListingConfigurableCsv.new(company_id: @company.id)

    assert_equal 1, report.csv_data.lines.count
  end

  test 'report output when one category to be included' do
    Keyword::StockListingFilter.create!(selite: 'osasto', selitetark: 'on', selitetark_2: '1000')
    report = StockListingConfigurableCsv.new(company_id: @company.id)

    assert_equal 1, report.csv_data.lines.count
  end

  test 'report output when one category to be excluded' do
    Keyword::StockListingFilter.create!(selite: 'osasto', selitetark: 'off', selitetark_2: '1000')
    report = StockListingConfigurableCsv.new(company_id: @company.id)

    assert_equal 2, report.csv_data.lines.count
  end

  test 'saving report to file' do
    report = StockListingConfigurableCsv.new(company_id: @company.id)
    filename = report.to_file

    # test we can make a file, and the content is same as csv data
    assert File.exist? filename
    assert_equal report.csv_data, File.open(filename, 'rb').read

    File.delete filename
  end
end
