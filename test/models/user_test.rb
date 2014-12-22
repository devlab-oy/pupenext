require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @joe = users(:joe)
    @bob = users(:bob)
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
    assert_equal 5, @joe.permissions.count
  end

  test "user has update permissions" do
    assert_equal 0, @joe.permissions.update_permissions.count
  end

  test 'read access' do
    assert @joe.permissions.read_access '/customers'
  end

  test 'update access' do
    assert @joe.permissions.update_access '/companies'
  end

  test "can read" do
    assert @joe.can_read? '/customers'
    refute @joe.can_read? '/test'
  end

  test "can update" do
    refute @joe.can_update? '/currencies'
    refute @joe.can_update? '/companies'

    assert @bob.can_update? '/currencies'
    assert @bob.can_update? '/companies'
  end

end
