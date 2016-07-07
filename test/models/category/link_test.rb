require 'test_helper'

class Category::LinkTest < ActiveSupport::TestCase
  fixtures %w(
    category/links
    category/products
    products
  )

  test 'fixtures are valid' do
    refute_empty Category::Link.all

    Category::Link.all.each do |link|
      assert link.valid?, link.errors.full_messages
    end
  end

  test 'associations' do
    assert_equal category_products(:product_category_shirts), category_links(:product_category_shirts_hammer).category
    assert_equal category_products(:product_category_pants),  category_links(:product_category_pants_helmet).category

    assert_equal products(:hammer), category_links(:product_category_shirts_hammer).product
    assert_equal products(:helmet), category_links(:product_category_pants_helmet).product
  end
end
