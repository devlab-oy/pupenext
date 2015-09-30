require 'test_helper'

class StockTransfer::RowTest < ActiveSupport::TestCase
  fixtures %w(
    stock_transfer/rows
    stock_transfer/orders
  )

  setup do
    @one = stock_transfer_rows :st_row_one
  end

  test 'fixtures are valid' do
    assert @one.valid?
  end

  test 'relations' do
    assert_equal "G", @one.order.tila
  end
end
