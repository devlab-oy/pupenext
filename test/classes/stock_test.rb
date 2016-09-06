require 'test_helper'

class StockTest < ActiveSupport::TestCase
  fixtures %w(
    products
    shelf_locations
  )

  setup do
    @product = products(:hammer)
    @stock   = Stock.new(@product)
  end

  test '#stock' do
    stock = @stock.stock
    assert stock > 0

    loc = @product.shelf_locations.first.dup
    loc.saldo = 100
    loc.hyllytaso = 'foo'
    loc.save!

    assert_equal stock + 100, Stock.new(@product).stock

    @product.update_attribute :ei_saldoa, :no_inventory_management
    assert_equal 0, Stock.new(@product).stock
  end

  test '#stock_reserved' do
    # these rows should affect reserved stock, let's zero them out
    @product.sales_order_rows.update_all(varattu: 0)
    @product.manufacture_rows.update_all(varattu: 0)
    @product.stock_transfer_rows.update_all(varattu: 0)
    assert_equal 0, Stock.new(@product).stock_reserved

    brand = keywords(:brand_tools)
    assert_equal brand.name, @product.brand.name

    @product.sales_order_rows.first.update!(varattu: 10)
    assert_equal 10, Stock.new(@product).stock_reserved

    @product.manufacture_rows.first.update!(varattu: 5)
    assert_equal 15, Stock.new(@product).stock_reserved

    @product.stock_transfer_rows.first.update!(varattu: 6)
    assert_equal 21, Stock.new(@product).stock_reserved

    @product.update_attribute :ei_saldoa, :no_inventory_management
    assert_equal 0, Stock.new(@product).stock_reserved
  end
end
