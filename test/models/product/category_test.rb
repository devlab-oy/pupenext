require 'test_helper'

class Product::CategoryTest < ActiveSupport::TestCase
  fixtures %w(products keywords)

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
    assert_not_equal 0, @category.subcategories.count
  end

  test 'fetch all brands' do
    assert_not_equal 0, @category.brands.count
  end
end
