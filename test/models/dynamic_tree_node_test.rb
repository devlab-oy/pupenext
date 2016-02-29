require 'test_helper'

class DynamicTreeNodeTest < ActiveSupport::TestCase
  fixtures %w(
    dynamic_tree_nodes
    dynamic_trees
  )

  setup do
    @one = dynamic_tree_nodes(:one)

    @dynamic_tree_one = dynamic_trees(:one)
  end

  test 'fixtures are valid' do
    assert @one.valid?, @one.errors.full_messages
  end

  test 'associations work' do
    assert_equal @dynamic_tree_one, @one.dynamic_tree
  end
end
