require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures %w(
    keywords
    manufacture_order/rows
    pending_updates
    product/suppliers
    products
    purchase_order/rows
    sales_order/rows
    shelf_locations
    stock_transfer/rows
    suppliers
  )

  setup do
    @product = products :hammer
  end

  test 'all fixtures should be valid' do
    assert @product.valid?
  end

  test 'relations' do
    assert_equal 'OSASTO', @product.category.laji
    assert_equal 'TRY', @product.subcategory.laji
    assert_equal 'TUOTEMERKKI', @product.brand.laji
    assert_equal 'S', @product.status.laji
    assert @product.manufacture_rows.count > 0
    assert @product.pending_updates.count > 0
    assert @product.product_suppliers.count > 0
    assert @product.purchase_order_rows.count > 0
    assert @product.sales_order_rows.count > 0
    assert @product.shelf_locations.count > 0
    assert @product.stock_transfer_rows.count > 0
    assert @product.suppliers.count > 0
  end

  test 'product stock' do
    stock = @product.stock
    assert stock > 0

    loc = @product.shelf_locations.first.dup
    loc.saldo = 100
    loc.hyllytaso = 'foo'
    loc.save!

    assert_equal stock + 100, @product.stock
  end

  test 'product reserved stock' do
    # these rows should affect reserved stock, let's zero them out
    @product.sales_order_rows.update_all(varattu: 0)
    @product.manufacture_rows.update_all(varattu: 0)
    @product.stock_transfer_rows.update_all(varattu: 0)
    assert_equal 0, @product.reserved_stock

    @product.sales_order_rows.first.update!(varattu: 10)
    assert_equal 10, @product.reserved_stock

    @product.manufacture_rows.first.update!(varattu: 5)
    assert_equal 15, @product.reserved_stock

    @product.stock_transfer_rows.first.update!(varattu: 6)
    assert_equal 21, @product.reserved_stock
  end

  test 'product stock available' do
    # these should affect stock available, let's zero them out
    @product.shelf_locations.update_all(saldo: 0)
    @product.sales_order_rows.update_all(varattu: 0)
    @product.manufacture_rows.update_all(varattu: 0)
    @product.stock_transfer_rows.update_all(varattu: 0)
    assert_equal 0, @product.stock_available

    @product.sales_order_rows.first.update!(varattu: 10)
    assert_equal -10, @product.stock_available

    @product.shelf_locations.first.update!(saldo: 100)
    assert_equal 90, @product.stock_available
  end
end
