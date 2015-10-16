require 'test_helper'

class ProductHelperTest < ActionView::TestCase
  fixtures %w(products)

  test "returns all of companys categories" do
    @params = {}
    assert_equal Current.company.categories.count, category_filter.count
  end

  test 'returns correct categories' do
    @params = {
      osasto: %w(1000 1001)
    }

    categories = [
      %w(Tools 1000),
      %w(Gears 1001),
    ]

    assert_equal categories, category_filter
  end

  test "returns all of companys subcategories" do
    @params = {}
    assert_equal Current.company.subcategories.count, subcatecory_filter.count
  end

  test 'returns correct subcategories' do
    @params = {
      try: %w(2000 2001),
    }

    subcategories = [
      ['Power tools', '2000'],
      ['Full-face helmet', '2001'],
    ]

    assert_equal subcategories, subcatecory_filter
  end

  test "returns all of companys brands" do
    @params = {}
    assert_equal Current.company.brands.count, brand_filter.count
  end

  test 'returns correct brands' do
    @params = {
      tuotemerkki: ['Bosch', 'Alpinestars']
    }

    brands = ['Alpinestars', 'Bosch']

    assert_equal brands, brand_filter
  end

  private

    # mock request params, so we can test helper
    def params
      @params
    end
end
