require 'test_helper'

class PendingProductUpdateHelperTest < ActionView::TestCase
  test "returns all of companys categories" do
    args = {}
    assert_equal Current.company.categories, categories_options(args)
  end

  test 'returns correct categories' do

    args = {
      osasto: '1000',
      try: '2000',
      tuotemerkki: 'Bosch'
    }

    expected = Product::Category.categories(args[:osasto]) +
               Product::Subcategory.categories(args[:try]) +
               Product::Brand.categories(args[:tuotemerkki])

    assert_equal expected, categories_options(args)
  end

  test "returns all of companys subcategories" do
    args = {}
    assert_equal Current.company.subcategories, subcategories_options(args)
  end

  test 'returns correct subcategories' do

    args = {
      osasto: '1000',
      try: '2000',
      tuotemerkki: 'Bosch'
    }

    expected = Product::Category.subcategories(args[:osasto]) +
               Product::Subcategory.subcategories(args[:try]) +
               Product::Brand.subcategories(args[:tuotemerkki])

    assert_equal expected, subcategories_options(args)
  end

  test "returns all of companys brands" do
    args = {}
    assert_equal Current.company.brands, brands_options(args)
  end

  test 'returns correct brands' do

    args = {
      osasto: '1000',
      try: '2000',
      tuotemerkki: 'Bosch'
    }

    expected = Product::Category.brands(args[:osasto]) +
               Product::Subcategory.brands(args[:try]) +
               Product::Brand.brands(args[:tuotemerkki])

    assert_equal expected, brands_options(args)
  end
end
