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
    assert_equal 'L', @one.order.tila
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

  test 'open scope' do
    all_rows = SalesOrder::Row.all

    # update all rows open, varattu non-zero
    all_rows.update_all varattu: 1, kpl: 0, jt: 0, laskutettuaika: 0
    assert_not_empty all_rows
    assert_equal all_rows.count, SalesOrder::Row.open.count

    # if jt non-zero, open
    all_rows.update_all varattu: 0, kpl: 0, jt: 1, laskutettuaika: 0
    assert_not_empty all_rows.open

    # if varattu and jt is zero, not open
    all_rows.update_all varattu: 0, kpl: 0, jt: 0, laskutettuaika: 0
    assert_empty all_rows.open

    # if laskutettu is non-zero, not open
    all_rows.update_all varattu: 1, kpl: 0, jt: 0, laskutettuaika: '2015-01-01'
    assert_empty all_rows.open
  end
end
