require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @joe = users(:joe)
  end

  test "user model" do
    assert User.new
  end

  test "fixture is valid" do
    assert @joe.valid?
  end

  test "user has a company" do
    assert_not_nil @joe.company
  end

  test "user has permissions" do
    assert_not_nil @joe.permissions
  end

  test "user has read permissions" do
    assert_equal 2, @joe.permissions.read_access.count
  end

  test "user has update permissions" do
    assert_equal 1, @joe.permissions.update_access.count
  end

end
