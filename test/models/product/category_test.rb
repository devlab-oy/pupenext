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

  test 'fetch all subcategories' do
    assert_equal Array, Product::Category.subcategories(@category[:selite]).first.class
    assert_not_equal 0, Product::Category.subcategories(@category[:selite]).count
  end

  test 'fetch all brands' do
    assert_equal Array, Product::Category.brands(@category[:selite]).first.class
    assert_not_equal 0, Product::Category.brands(@category[:selite]).count
  end
end
