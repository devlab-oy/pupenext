require 'test_helper'

class Product::GroupTest < ActiveSupport::TestCase
  fixtures %w(products keywords)

  setup do
    @group = keywords :group_tools
  end

  test 'all fixtures should be valid' do
    assert @group.valid?
  end

  test 'relations' do
    product = products :hammer
    assert_equal product.nimitys, @group.products.first.nimitys
  end
end
