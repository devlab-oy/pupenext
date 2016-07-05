require 'test_helper'

class PurchaseOrder::RowTest < ActiveSupport::TestCase
  fixtures %w(
    arrivals
    heads
    products
    purchase_order/orders
    purchase_order/rows
  )

  setup do
    @one = purchase_order_rows :po_row_one
  end

  test 'fixtures are valid' do
    assert @one.valid?
  end

  test 'relations' do
    assert_equal 'O', @one.order.tila
    assert_equal 'K', @one.arrival.tila
  end

  test 'open scope' do
    assert_equal 0, @one.order.rows.open.count
  end
end
