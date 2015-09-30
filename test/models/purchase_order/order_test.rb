require 'test_helper'

class PurchaseOrder::OrderTest < ActiveSupport::TestCase
  fixtures %w(
    head/voucher_rows
    purchase_order/orders
    purchase_order/rows
  )

  setup do
    @order = purchase_order_orders(:po_one)
  end

  test 'fixture should be valid' do
    assert @order.valid?
    assert_equal "Acme Corporation", @order.company.nimi
  end

  test 'model relations' do
    assert @order.accounting_rows.count > 0
    assert @order.rows.count > 0
  end
end
