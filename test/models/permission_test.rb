require 'test_helper'

class PermissionTest < ActiveSupport::TestCase
  fixtures %w(permissions)

  setup do
    @perms = permissions(:joe_customers_read)
  end

  test "permission model" do
    assert Permission.new
  end

  test "fixture is valid" do
    assert @perms.valid?, @perms.errors.full_messages
  end

  test "permission has a user" do
    assert_not_nil @perms.user
  end

end
