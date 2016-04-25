require 'test_helper'

class Category::ProductTest < ActiveSupport::TestCase
  fixtures %w(
    products
    category/products
  )

  setup do
    @shirts = category_products :product_category_shirts
    @pants  = category_products :product_category_pants
  end

  test 'fixtures are valid' do
    assert @shirts.valid?, @shirts.errors.full_messages
    assert @pants.valid?,  @pants.errors.full_messages
  end

  test 'associations work' do
    assert_equal "Acme Corporation", @shirts.company.nimi
  end
end
