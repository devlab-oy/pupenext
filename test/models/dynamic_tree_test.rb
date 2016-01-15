require 'test_helper'

class DynamicTreeTest < ActiveSupport::TestCase
  fixtures %w(
    dynamic_tree_nodes
    dynamic_trees
    products
    supplier_product_informations
  )

  setup do
    @one = dynamic_trees(:one)
  end

  test 'fixtures are valid' do
    assert @one.valid?, @one.errors.full_messages
  end

  test 'associations work' do
    assert_includes @one.supplier_product_informations, supplier_product_informations(:one)
    assert_includes @one.product_nodes,                 dynamic_tree_nodes(:one)
    assert_includes @one.products,                      products(:hammer)
  end
end
