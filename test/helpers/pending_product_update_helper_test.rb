require 'test_helper'

class PendingProductUpdateHelperTest < ActionView::TestCase
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
end
