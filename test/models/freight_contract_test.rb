require 'test_helper'

class FreightContractTest < ActiveSupport::TestCase
  setup do
    @one = freight_contracts(:one)
    @two = freight_contracts(:two)
  end

  test "fixtures are valid" do
    assert @one.valid?, @one.errors.full_messages
    assert @two.valid?, @two.errors.full_messages
  end
end
