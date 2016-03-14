require 'test_helper'

class Reports::CustomerPriceListTest < ActiveSupport::TestCase
  fixtures %w(
    keyword/customer_subcategories
    customers
    products
  )
  setup do

  end

  test 'initialize with correct values' do
    report = Reports::CustomerPriceList.new(
      products: Product.all,
      customer: customers(:stubborn_customer),
      customer_subcategory: keyword_customer_subcategories(:customer_subcategory_2),
      lyhytkuvaus: true,
      kuvaus: false,
      date_start: Date.today,
      date_end: Date.tomorrow
    )

    assert_equal Product.all.count, report.products.count
    assert_equal customers(:stubborn_customer), report.customer
    assert_equal keyword_customer_subcategories(:customer_subcategory_2),
                 report.customer_subcategory
    assert_equal true, report.lyhytkuvaus
    assert_equal false, report.kuvaus
    assert_equal Date.today, report.date_start
    assert_equal Date.tomorrow, report.date_end
  end
end
