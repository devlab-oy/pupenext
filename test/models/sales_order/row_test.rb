require 'test_helper'

class SalesOrder::RowTest < ActiveSupport::TestCase
  fixtures %w(
    products
    sales_order/orders
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

  test 'reserved' do
    @one.order.rows.update_all varattu: 0

    assert_equal 0, @one.varattu
    assert_equal 0, @one.order.rows.reserved

    @one.update_attributes! varattu: 10, var: ''
    assert_equal 10, @one.order.rows.reserved

    @one.update_attributes! varattu: -10, var: ''
    assert_equal 0, @one.order.rows.reserved

    @one.update_attributes! varattu: 15, var: 'P'
    assert_equal 0, @one.order.rows.reserved
  end

  test 'picked scope' do
    @one.order.rows.update_all keratty: ''

    assert_equal '', @one.keratty
    assert_equal 0, @one.order.rows.picked.count

    @one.update_attributes! keratty: 'joe'
    assert_equal 1, @one.order.rows.picked.count
  end

  test '#parent?' do
    refute @one.parent?
    @one.perheid = @one.tunnus
    assert @one.parent?
  end
end
