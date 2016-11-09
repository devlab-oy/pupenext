require 'test_helper'

class Woo::ProductsTest < ActiveSupport::TestCase
  setup do
    @woocommerce = Woo::Products.new
  end

  test 'should initialize' do
    assert_instance_of Woo::Products, @woocommerce
  end

  test 'creates products to woocommerce' do
    response = Woo::Products.new.create
    assert_equal "", response
  end

  test 'get products' do
    assert_equal "", Woo::Products.new.get_products
  end

  test 'product data hash' do
    response = {name: 'Combosukset', slug: 'ski1', type: 'simple', description: nil, short_description: nil, regular_price: 0.0, stock_quantity: 0.0}
    product = Woo::Products.new.get_products.first
    assert_equal response, Woo::Products.new.product_data(product)
  end

  test 'filter products from woocommerce' do
    assert_equal "", Woo::Products.new.find_by_sku('123')["id"]
  end
end
