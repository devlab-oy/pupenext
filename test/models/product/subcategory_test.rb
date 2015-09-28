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

  test 'fetch all categories' do
    assert_equal Product::Category, Product::Subcategory.categories(@subcategory[:selite]).first.class
    assert_not_equal 0, Product::Subcategory.categories(@subcategory[:selite]).count
  end

  test 'fetch all brands' do
    assert_equal Product::Brand, Product::Subcategory.brands(@subcategory[:selite]).first.class
    assert_not_equal 0, Product::Subcategory.brands(@subcategory[:selite]).count
  end
end
