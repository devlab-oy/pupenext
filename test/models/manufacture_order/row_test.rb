require 'test_helper'

class ManufactureOrder::RowTest < ActiveSupport::TestCase
  fixtures %w(
    manufacture_order/orders
    manufacture_order/rows
  )

  setup do
    @one = manufacture_order_rows :mo_row_one
  end

  test 'fixtures are valid' do
    assert @one.valid?
  end

  test 'relations' do
    assert_equal "V", @one.order.tila
  end
end
