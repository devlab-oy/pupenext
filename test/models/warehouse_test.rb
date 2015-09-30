require 'test_helper'

class WarehouseTest < ActiveSupport::TestCase
  fixtures %w(warehouses packing_areas shelf_locations)

  setup do
    @veikkola = warehouses(:veikkola)
  end

  test "fixtures are valid" do
    assert @veikkola.valid?
  end

  test "relations" do
    assert @veikkola.packing_areas.count > 0
    assert @veikkola.shelf_locations.count > 0
  end
end
