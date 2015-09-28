require 'test_helper'

class PendingProductUpdateHelperTest < ActionView::TestCase
  test "returns all of companys subcategories" do
    args = {}
    assert_equal Current.company.subcategories, subcategories_options(args)
  end

  test 'returns correct subcategories' do
    args = { osasto: '1000' }
    assert_equal Product::Category.subcategories(args[:osasto]), subcategories_options(args)
  end
end
