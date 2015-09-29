require 'test_helper'

class ProductHelperTest < ActionView::TestCase
  fixtures %w(products)

  test "returns all of companys categories" do
    args = {}
    assert_equal Current.company.categories.count, categories_options(args).count
  end

  test 'returns correct categories' do
    args = {
      category: ['1000', '1001']
    }

    categories = [
      ['1000', 'Tools'],
      ['1001', 'Gears'],
      ['1005', 'Winter']
    ]

    assert_equal categories, categories_options(args)
  end

  test "returns all of companys subcategories" do
    args = {}
    assert_equal Current.company.subcategories.count, subcategories_options(args).count
  end

  test 'returns correct subcategories' do
    args = {
      subcategory: ['2000', '2001'],
    }

    subcategories = [
      ['2000', 'Power tools'],
      ['2001', 'Full-face helmet'],
    ]

    assert_equal subcategories, subcategories_options(args)
  end

  test "returns all of companys brands" do
    args = {}
    assert_equal Current.company.brands.count, brands_options(args).count
  end

  test 'returns correct brands' do
    args = {
      brand: ['Bosch', 'Alpinestars']
    }

    brands = ['Alpinestars', 'Bosch']

    assert_equal brands, brands_options(args)
  end
end
