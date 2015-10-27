require 'test_helper'

class SalesOrder::RowTest < ActiveSupport::TestCase
  fixtures %w(
    sales_order/base/orders
    sales_order/rows
  )

  setup do
    @one = sales_order_rows :so_row_one
  end

  test 'fixtures are valid' do
    assert @one.valid?
  end

  test 'relations' do
    assert_equal "L", @one.order.tila
  end
end
