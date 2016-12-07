require 'minitest/mock'
require 'test_helper'

class Woo::ProductsTest < ActiveSupport::TestCase
  fixtures %w(
    products
  )

  setup do
    @woocommerce = Woo::Products.new(company_id: companies(:acme).id)
    Product.update_all(hinnastoon: '')
    products(:ski).update(hinnastoon: 'w')
  end

  test 'should initialize' do
    assert_instance_of Woo::Products, @woocommerce
  end

  test 'get products' do
    assert_equal 1, @woocommerce.send(:products).count
  end

  test 'product hash' do
    response = {
      name: 'Combosukset',
      slug: 'ski1',
      sku: 'ski1',
      type: 'simple',
      description: nil,
      short_description: nil,
      regular_price: '0.0',
      manage_stock: true,
      stock_quantity: '0.0',
      status: 'pending',
    }

    product = @woocommerce.send(:products).first
    assert_equal response, @woocommerce.send(:product_hash, product)
  end
end
