require 'test_helper'

class ProductHelperTest < ActionView::TestCase
  fixtures %w(products)

  test "returns all of companys categories" do
    args = {}
    assert_equal Current.company.categories.count, categories_options(args).count
  end

  test 'returns correct categories' do
    args = {
      categories: %w(1000 1001)
    }

    categories = [
      %w(Tools 1000),
      %w(Gears 1001),
    ]

    assert_equal categories, categories_options(args)
  end

  test "returns all of companys subcategories" do
    args = {}
    assert_equal Current.company.subcategories.count, subcategories_options(args).count
  end

  test 'returns correct subcategories' do
    args = {
      subcategories: %w(2000 2001),
    }

    subcategories = [
      ['Power tools', '2000'],
      ['Full-face helmet', '2001'],
    ]

    assert_equal subcategories, subcategories_options(args)
  end

  test "returns all of companys brands" do
    args = {}
    assert_equal Current.company.brands.count, brands_options(args).count
  end

  test 'returns correct brands' do
    args = {
      brands: ['Bosch', 'Alpinestars']
    }

    brands = ['Alpinestars', 'Bosch']

    assert_equal brands, brands_options(args)
  end
end
