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

end
