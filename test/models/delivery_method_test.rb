require 'test_helper'

class DeliveryMethodTest < ActiveSupport::TestCase
  setup do
    @lento = delivery_methods(:lento)
    @laiva = delivery_methods(:laiva)
  end

  test "fixtures are valid" do
    assert @lento.valid?, @lento.errors.full_messages
    assert @laiva.valid?, @laiva.errors.full_messages
  end
end
