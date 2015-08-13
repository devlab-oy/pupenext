require 'test_helper'

class WarehouseTest < ActiveSupport::TestCase
  setup do
    @veikkola = warehouses(:veikkola)
  end

  test "fixtures are valid" do
    assert @veikkola.valid?
  end
end
