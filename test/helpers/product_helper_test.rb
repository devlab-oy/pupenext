require 'test_helper'

class ProductHelperTest < ActionView::TestCase
  fixtures %w(products)

  test "returns all of companys categories" do
    @params = {}
    assert_equal Current.company.categories.count, category_filter.count
  end

  test 'returns correct categories' do
    @params = {
      osasto: %w(1000 1001),
      try: %w(2000 2001),
      tuotemerkki: %w(Bosch Alpinestars),
    }

    categories = [
      ['1000 - Tools', '1000'],
      ['1001 - Gears', '1001'],
      ["1005 - Winter", "1005"],
    ]

    # categories always return all categories
    assert_equal categories, category_filter
    assert_equal Current.company.categories.count, category_filter.count
  end

  test 'returns correct subcategories' do
    @params = {
      try: %w(2000 2001),
      tuotemerkki: %w(Bosch Alpinestars),
    }

    subcategories = [
      ['2000 - Power tools', '2000'],
      ['2001 - Full-face helmet', '2001'],
    ]

    # if we don't filter by categories, we'll always get all subcategories
    assert_equal subcategories, subcategory_filter
    assert_equal Current.company.subcategories.count, subcategory_filter.count
  end

  test 'returns correct brands' do
    @params = {
      tuotemerkki: %w(Bosch Alpinestars)
    }

    brands = %w(Alpinestars Bosch Karhu)

    # if we don't filter by categories or subcategories, we'll always get all brands
    assert_equal brands, brand_filter
    assert_equal Current.company.brands.count, brand_filter.count
  end

  private

    # mock request params, so we can test helper
    def params
      @params
    end

    # mock current user, so we can test helper
    def current_user
      @current_user ||= users(:bob)
    end
end
