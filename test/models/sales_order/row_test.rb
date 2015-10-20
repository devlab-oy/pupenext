require 'test_helper'

class Head::SalesOrder::RowTest < ActiveSupport::TestCase
  fixtures %w(
    head/sales_order/orders
    head/sales_order/rows
  )

  setup do
    @one = head_sales_order_rows :so_row_one
  end

  test 'fixtures are valid' do
    assert @one.valid?
  end

  test 'relations' do
    assert_equal "L", @one.order.tila
  end
end
