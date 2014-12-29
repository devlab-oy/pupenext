require "test_helper"

class KeywordTest < ActiveSupport::TestCase
  setup do
    @one = keywords(:one)
  end

  test "option_value works" do
    assert_equal "Testing keyword %", @one.option_value
  end
end
