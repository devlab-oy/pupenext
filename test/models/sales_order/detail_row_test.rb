require 'test_helper'

class SalesOrder::DetailRowTest < ActiveSupport::TestCase
  fixtures %w(
    products
    sales_order/detail_rows
    sales_order/details
  )

  setup do
    @one = sales_order_detail_rows :do_row_one
  end

  test 'fixtures are valid' do
    assert @one.valid?
  end

  test 'relations' do
    assert_equal "9", @one.order.tila
  end
end
