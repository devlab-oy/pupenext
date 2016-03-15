require 'test_helper'

class Reports::CustomerPriceListTest < ActiveSupport::TestCase
  fixtures %w(
    customers
    keyword/customer_price_list_attributes
    keyword/customer_subcategories
    products
  )
  setup do
    @report = Reports::CustomerPriceList.new(
      products: Product.all,
      customer: customers(:stubborn_customer),
      customer_subcategory: keyword_customer_subcategories(:customer_subcategory_2),
      lyhytkuvaus: true,
      kuvaus: false,
      date_start: Date.today,
      date_end: Date.tomorrow
    )
  end

  test 'initialize with correct values' do
    assert_equal Product.all.count, @report.products.count
    assert_equal customers(:stubborn_customer), @report.customer
    assert_equal keyword_customer_subcategories(:customer_subcategory_2),
                 @report.customer_subcategory
    assert_equal true, @report.lyhytkuvaus
    assert_equal false, @report.kuvaus
    assert_equal Date.today, @report.date_start
    assert_equal Date.tomorrow, @report.date_end
  end

  test 'initialize with incorrect values' do
    assert_raise ArgumentError do
      Reports::CustomerPriceList.new(products: nil)
    end
  end

  test '#validity when date_start and date_end are given' do
    assert_equal "#{I18n.l Date.today} - #{I18n.l Date.tomorrow}", @report.validity
  end

  test '#validity when date_start and date_end are not given' do
    report = Reports::CustomerPriceList.new(products: Product.all)

    assert_equal I18n.t('reports.customer_price_lists.report.indefinitely'), report.validity
  end

  test '.message' do
    assert_equal Keyword::CustomerPriceListAttribute.message, Reports::CustomerPriceList.message
  end
end
