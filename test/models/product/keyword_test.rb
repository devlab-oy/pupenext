require 'test_helper'

class Product::KeywordTest < ActiveSupport::TestCase
  fixtures %w(
    product/keywords
    products
  )

  setup do
    @keyword = product_keywords :one
  end

  test 'all fixtures should be valid' do
    assert @keyword.valid?
  end

  test 'relations' do
    assert_equal Product, @keyword.product.class
    assert_equal String, @keyword.product.nimitys.class
  end
end
