require 'test_helper'

class ShelfLocationTest < ActiveSupport::TestCase
  fixtures %w(shelf_locations products warehouses)

  setup do
    @location = shelf_locations :one
  end

  test 'fixtures are valid' do
    assert @location.valid?
  end

  test 'relations' do
    warehouse = warehouses :veikkola
    assert_equal warehouse.nimitys, @location.warehouse.nimitys

    product = products :hammer
    assert_equal product.nimitys, @location.product.nimitys
  end
end
