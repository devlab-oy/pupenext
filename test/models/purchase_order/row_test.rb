require 'test_helper'

class PurchaseOrder::RowTest < ActiveSupport::TestCase
  fixtures %w(heads purchase_order/rows)

  setup do
    @one = purchase_order_rows :po_row_one
  end

  test 'fixtures are valid' do
    assert @one.valid?
  end

  test 'relations' do
    assert_equal "O", @one.order.tila
  end
end
