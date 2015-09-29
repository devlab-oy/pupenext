require 'test_helper'

# Create dummy class for testing CategoryFilter concern using Product::Category class
class CategoryFilterTest < ActiveSupport::TestCase
  fixtures %w(products keywords)

  test 'filter method should return collection of Categories' do
    klass = Product::Category::ActiveRecord_Relation
    assert_equal klass, Product::Category.filter.class
  end

  test 'element shoud be a category' do
    klass = Product::Category
    assert_equal klass, Product::Category.filter.first.class
  end

  test 'filtering works' do
    assert_not_equal 0, Product::Category.filter.count
  end

  test 'filter by categories' do
    response = ['Tools', 'Gears']
    assert_equal response, Product::Category.filter(categories: [1000, 1001]).map(&:description)
  end

  test 'filter by subcategories' do
    response = ['Tools', 'Gears', 'Winter']
    assert_equal response, Product::Category.filter(subcategories: [2000, 2001]).map(&:description)
  end

  test 'filter by brands' do
    response = ['Gears']
    assert_equal response, Product::Category.filter(brands: 'Alpinestars').map(&:description)
  end

  test 'filter by all' do
    filter = { brands: 'Karhu', subcategories: 2001, categories: 1005 }
    response = ['Winter']
    assert_equal response, Product::Category.filter(filter).map(&:description)
  end
end
