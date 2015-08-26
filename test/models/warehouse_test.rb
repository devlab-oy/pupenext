require 'test_helper'

class WarehouseTest < ActiveSupport::TestCase
  setup do
    @veikkola = warehouses(:veikkola)
  end

  test "fixtures are valid" do
    assert @veikkola.valid?
  end

  test "relations" do
    assert_equal 2, @veikkola.packing_areas.count
  end
end
