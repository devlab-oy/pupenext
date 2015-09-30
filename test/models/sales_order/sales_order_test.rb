require 'test_helper'

class SalesOrder::OrderTest < ActiveSupport::TestCase
  fixtures %w(sales_order/orders head/voucher_rows)

  setup do
    @order = sales_order_orders(:so_one)
  end

  test 'fixture should be valid' do
    assert @order.valid?
    assert_equal "Acme Corporation", @order.company.nimi
  end

  test 'model relations' do
    assert_equal 1, @order.accounting_rows.count
  end
end
