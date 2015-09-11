require 'test_helper'

class Product::BrandTest < ActiveSupport::TestCase
  fixtures %w(products keywords)

  setup do
    @brand = keywords :brand_tools
  end

  test 'all fixtures should be valid' do
    assert @brand.valid?
  end

  test 'relations' do
    product = products :hammer
    assert_equal product.nimitys, @brand.products.first.nimitys

    assert_equal Product::Brand, @brand.class
  end
end
