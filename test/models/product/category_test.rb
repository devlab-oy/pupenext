require 'test_helper'

class Product::CategoryTest < ActiveSupport::TestCase
  fixtures %w(products)

  setup do
    @category = keywords :category_tools
  end

  test 'all fixtures should be valid' do
    assert @category.valid?
  end

  test 'relations' do
    product = products :hammer
    assert_equal product.nimitys, @category.products.first.nimitys

    assert_equal Product::Category, @category.class
  end
end
