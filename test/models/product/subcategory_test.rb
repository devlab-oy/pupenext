require 'test_helper'

class Product::SubcategoryTest < ActiveSupport::TestCase
  fixtures %w(products keywords)

  setup do
    @subcategory = keywords :subcategory_tools
  end

  test 'all fixtures should be valid' do
    assert @subcategory.valid?
  end

  test 'relations' do
    product = products :hammer
    assert_equal product.nimitys, @subcategory.products.first.nimitys

    assert_equal Product::Subcategory, @subcategory.class
  end
end
