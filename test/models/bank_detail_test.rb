require "test_helper"

class BankDetailTest < ActiveSupport::TestCase
  setup do
    @one = bank_details(:one)
  end

  test "fixtures are valid" do
    assert @one.valid?
  end
end
