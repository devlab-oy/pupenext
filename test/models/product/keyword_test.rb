require 'test_helper'

class Product::KeywordTest < ActiveSupport::TestCase
  fixtures %w(
    keyword/product_information_types
    keyword/product_keyword_types
    keyword/product_parameter_types
    product/keywords
    products
  )

  setup do
    @nimitys = product_keywords :one
    @material = product_keywords :two
  end

  test 'all fixtures should be valid' do
    assert @nimitys.valid?, @nimitys.errors.full_messages
    assert @material.valid?, @material.errors.full_messages
  end

  test 'relations' do
    assert_equal Product, @nimitys.product.class
    assert_equal String, @nimitys.product.nimitys.class
  end
end
