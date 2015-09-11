require 'test_helper'

class Product::BrandTest < ActiveSupport::TestCase
  fixtures %w(products keywords)

  setup do
    @brand = keywords :brand_tools
  end

  test 'all fixtures should be valid' do
    assert @brand.valid?
  end

  test 'relations' do
    product = products :hammer
    assert_equal product.nimitys, @brand.products.first.nimitys

    assert_equal Product::Brand, @brand.class
  end

  test 'fetch all categories' do
    assert_not_equal 0, @brand.categories.count
  end

  test 'fetch all subcategories' do
    assert_not_equal 0, @brand.subcategories.count
  end
end
