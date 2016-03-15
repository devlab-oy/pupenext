require 'test_helper'
require 'minitest/mock'

class Reports::CustomerPriceListProductTest < ActiveSupport::TestCase
  fixtures %w(
    customers
    keyword/customer_subcategories
    products
  )

  setup do
    Current.user = users(:bob)

    @report = Reports::CustomerPriceListProduct.new(
      product: products(:hammer),
      customer: customers(:stubborn_customer)
    )
  end

  test 'initialize with incorrect values' do
    assert_raise ArgumentError do
      Reports::CustomerPriceListProduct.new(
        product: products(:hammer)
      )
    end
  end

  test '#price when customer is given' do
    price = { hinta: 18.85, hinta_peruste: 18, ale_peruste: 3, contract_price: true }

    LegacyMethods.stub(:customer_price_with_info, price) do
      assert_equal price, @report.price
    end
  end

  test '#price when customer subcategory is given' do
    report = Reports::CustomerPriceListProduct.new(
      product: products(:hammer),
      customer_subcategory: keyword_customer_subcategories(:customer_subcategory_1)
    )

    price = { hinta: 852.44, hinta_peruste: 18, ale_peruste: 3, contract_price: false }

    LegacyMethods.stub(:customer_subcategory_price_with_info, price) do
      assert_equal price, report.price
    end
  end

  test '#contract_price' do
    assert_equal I18n.t('simple_form.yes'), @report.contract_price
  end
end
