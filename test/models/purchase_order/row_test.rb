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
    all_rows = PurchaseOrder::Row.all

    # update all rows open, varattu non-zero
    all_rows.update_all varattu: 1, kpl: 0, jt: 0, laskutettuaika: 0
    assert_not_empty all_rows
    assert_equal all_rows.count, PurchaseOrder::Row.open.count

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
