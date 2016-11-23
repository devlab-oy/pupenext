require 'minitest/mock'
require 'test_helper'

class Woo::ProductsTest < ActiveSupport::TestCase
  fixtures %w(
    products
  )

  setup do
    @woocommerce = Woo::Products.new
  end

  test 'should initialize' do
    assert_instance_of Woo::Products, @woocommerce
  end

  test 'get products' do
    products(:ski).update(hinnastoon: 'w')
    assert_equal 1, Woo::Products.new.get_products.count
  end

  test 'product hash' do
    products(:ski).update(hinnastoon: 'w')
    response = {name: 'Combosukset', slug: 'ski1', sku: 'ski1', type: 'simple', description: nil, short_description: nil, regular_price: '0.0', manage_stock: true, stock_quantity: '0.0', status: 'pending'}
    product = Woo::Products.new.get_products.first
    assert_equal response, Woo::Products.new.product_hash(product)
  end

  test 'filter products from woocommerce' do
    #assert_equal "", Woo::Products.new.find_by_sku('123')["id"]
  end
end
