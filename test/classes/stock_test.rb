require 'test_helper'

class StockTest < ActiveSupport::TestCase
  fixtures %w(
    manufacture_order/rows
    products
    sales_order/rows
    shelf_locations
    stock_transfer/rows
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

  test '#stock_available' do
    # these should affect stock available, let's zero them out
    @product.shelf_locations.update_all(saldo: 0)
    @product.sales_order_rows.update_all(varattu: 0)
    @product.manufacture_rows.update_all(varattu: 0)
    @product.stock_transfer_rows.update_all(varattu: 0)
    assert_equal 0, Stock.new(@product).stock_available

    @product.sales_order_rows.first.update!(varattu: 10)
    assert_equal -10, Stock.new(@product).stock_available

    @product.shelf_locations.first.update!(saldo: 100)
    assert_equal 90, Stock.new(@product).stock_available

    @product.update_attribute :ei_saldoa, :no_inventory_management
    assert_equal 0, Stock.new(@product).stock_available
  end

  test 'sales order rows product stock is reserved by pick date' do
    # set stock management by pick date
    @product.company.parameter.update!(saldo_kasittely: :stock_management_by_pick_date)
    assert_equal 0, Stock.new(@product).stock_reserved

    one = @product.sales_order_rows.first.dup
    two = @product.sales_order_rows.first.dup

    # SO rows due to be picked today or in the past, should reserve stock (picked or not picked)
    one.update!(kerayspvm: Date.current, varattu: 10, keratty: '')
    two.update!(kerayspvm: Date.current, varattu: 10, keratty: 'joe')
    assert_equal 20, Stock.new(@product).stock_reserved

    # SO rows due to be picked in the future, should not affect reserve stock, unless picked
    one.update!(kerayspvm: 1.day.from_now, varattu: 5,  keratty: '')
    two.update!(kerayspvm: 1.day.from_now, varattu: 15, keratty: 'joe')
    assert_equal 15, Stock.new(@product).stock_reserved
  end

  test 'manufacture rows product stock is reserved by pick date' do
    # set stock management by pick date
    @product.company.parameter.update! saldo_kasittely: :stock_management_by_pick_date
    assert_equal 0, Stock.new(@product).stock_reserved

    one = @product.manufacture_rows.first.dup
    two = @product.manufacture_rows.first.dup

    # MF rows due to be picked today or in the past, should reserve stock (picked or not picked)
    one.update!(kerayspvm: Date.current, varattu: 10, keratty: '')
    two.update!(kerayspvm: Date.current, varattu: 10, keratty: 'joe')
    assert_equal 20, Stock.new(@product).stock_reserved

    # MF rows due to be picked in the future, should not affect reserve stock, unless picked
    one.update!(kerayspvm: 1.day.from_now, varattu: 5,  keratty: '')
    two.update!(kerayspvm: 1.day.from_now, varattu: 15, keratty: 'joe')
    assert_equal 15, Stock.new(@product).stock_reserved
  end
end
