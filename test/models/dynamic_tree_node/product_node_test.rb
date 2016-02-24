require 'test_helper'

class DynamicTreeNode::ProductNodeTest < ActiveSupport::TestCase
  fixtures %w(
    dynamic_tree_nodes
    products
  )

  setup do
    @one = dynamic_tree_nodes(:one)

    @hammer = products(:hammer)
  end

  test 'fixtures are valid' do
    assert @one.valid?, @one.errors.full_messages
  end

  test 'associations work' do
    assert_equal @hammer, @one.product
  end
end
