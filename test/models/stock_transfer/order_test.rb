require 'test_helper'

class StockTransfer::OrderTest < ActiveSupport::TestCase
  fixtures %w(
    stock_transfer/orders
    stock_transfer/rows
  )

  setup do
    @order = stock_transfer_orders(:st_one)
  end

  test 'fixture should be valid' do
    assert @order.valid?
    assert_equal "Acme Corporation", @order.company.nimi
  end

  test 'model relations' do
    assert @order.rows.count > 0
    assert_equal "G", @order.rows.first.tyyppi
  end
end
