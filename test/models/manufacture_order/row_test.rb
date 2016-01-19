require 'test_helper'

class ManufactureOrder::RowTest < ActiveSupport::TestCase
  fixtures %w(
    manufacture_order/composite_rows
    manufacture_order/orders
    manufacture_order/recursive_composite_rows
    manufacture_order/rows
    products
  )

  setup do
    @one = manufacture_order_rows :mo_row_one
    @two = manufacture_order_composite_rows :mo_composite_row_one
    @three = manufacture_order_recursive_composite_rows :mo_recursive_composite_row_one
  end

  test 'fixtures are valid' do
    assert @one.valid?
    assert @two.valid?
    assert @three.valid?
  end

  test 'relations' do
    assert_equal "V", @one.order.tila
    assert_equal "V", @two.order.tila
    assert_equal "V", @three.order.tila
  end
end
