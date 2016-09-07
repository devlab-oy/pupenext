require 'test_helper'

class StockTest < ActiveSupport::TestCase
  fixtures %w(
    manufacture_order/composite_rows
    manufacture_order/recursive_composite_rows
    manufacture_order/rows
    products
    purchase_order/rows
    sales_order/rows
    shelf_locations
    stock_transfer/rows
    warehouses
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

  test '#stock with warehouses specified' do
    stock = Stock.new(@product, warehouse_ids: [warehouses(:kontula).id])

    assert_equal 2, stock.stock
  end

  test '#stock_per_warehouse' do
    stock = Stock.new(@product, warehouse_ids: [warehouses(:veikkola).id, warehouses(:kontula).id])
    stock_per_warehouse = stock.stock_per_warehouse

    assert_equal({ warehouses(:veikkola).id => 10, warehouses(:kontula).id => 2 }, stock_per_warehouse)
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

  test '#stock_reserved_per_warehouse' do
    @product.sales_order_rows.update_all(varattu: 0)
    @product.manufacture_rows.update_all(varattu: 0)
    @product.stock_transfer_rows.update_all(varattu: 0)

    @product.sales_order_rows.first.update!(varattu: 10, varasto: warehouses(:veikkola).id)
    stock = Stock.new(@product, warehouse_ids: [warehouses(:veikkola).id, warehouses(:kontula).id])
    assert_equal({ warehouses(:veikkola).id => 10, warehouses(:kontula).id => 0 }, stock.stock_reserved_per_warehouse)
  end

  test '#stock_reserved with warehouses specified' do
    # these rows should affect reserved stock, let's zero them out
    @product.sales_order_rows.update_all(varattu: 0)
    @product.manufacture_rows.update_all(varattu: 0)
    @product.stock_transfer_rows.update_all(varattu: 0)
    assert_equal 0, Stock.new(@product, warehouse_ids: [warehouses(:kontula).id]).stock_reserved

    brand = keywords(:brand_tools)
    assert_equal brand.name, @product.brand.name

    @product.sales_order_rows.first.update!(varattu: 10, warehouse: warehouses(:veikkola))
    @product.sales_order_rows.second.update!(varattu: 1, warehouse: warehouses(:kontula))
    assert_equal 10, Stock.new(@product, warehouse_ids: [warehouses(:veikkola).id]).stock_reserved

    @product.manufacture_rows.first.update!(varattu: 5, warehouse: warehouses(:kontula))
    @product.manufacture_rows.second.update!(varattu: 7, warehouse: warehouses(:veikkola))
    assert_equal 6, Stock.new(@product, warehouse_ids: [warehouses(:kontula).id]).stock_reserved

    @product.stock_transfer_rows.first.update!(varattu: 9, warehouse: warehouses(:veikkola))
    @product.stock_transfer_rows.second.update!(varattu: 3, warehouse: warehouses(:kontula))
    assert_equal 26, Stock.new(@product, warehouse_ids: [warehouses(:veikkola).id]).stock_reserved

    @product.update_attribute :ei_saldoa, :no_inventory_management
    assert_equal 0, Stock.new(@product, warehouse_ids: [warehouses(:kontula).id]).stock_reserved
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

  test '#stock_available_per_warehouse' do
    @product.shelf_locations.update_all(saldo: 0)
    @product.sales_order_rows.update_all(varattu: 0)
    @product.manufacture_rows.update_all(varattu: 0)
    @product.stock_transfer_rows.update_all(varattu: 0)

    @product.sales_order_rows.first.update!(varattu: 10, varasto: warehouses(:veikkola).id)

    stock = Stock.new(@product, warehouse_ids: [warehouses(:veikkola).id]).stock_available_per_warehouse

    assert_equal({ warehouses(:veikkola).id => -10 }, stock)
  end

  test '#stock_available with warehouses specified' do
    # these should affect stock available, let's zero them out
    @product.shelf_locations.update_all(saldo: 0)
    @product.sales_order_rows.update_all(varattu: 0)
    @product.manufacture_rows.update_all(varattu: 0)
    @product.stock_transfer_rows.update_all(varattu: 0)
    assert_equal 0, Stock.new(@product, warehouse_ids: [warehouses(:veikkola).id]).stock_available

    @product.sales_order_rows.first.update!(varattu: 8, warehouse: warehouses(:veikkola))
    @product.sales_order_rows.second.update!(varattu: 16, warehouse: warehouses(:kontula))
    assert_equal -16, Stock.new(@product, warehouse_ids: [warehouses(:kontula)]).stock_available

    shelf_locations(:two).update!(saldo: 100)
    assert_equal 84, Stock.new(@product, warehouse_ids: [warehouses(:kontula).id]).stock_available

    @product.update_attribute :ei_saldoa, :no_inventory_management
    assert_equal 0, Stock.new(@product, warehouse_ids: [warehouses(:veikkola).id]).stock_available
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

  test 'stock_transfer_rows product stock is reserved by pick date' do
    # set stock management by pick date
    @product.company.parameter.update!(saldo_kasittely: :stock_management_by_pick_date)
    assert_equal 0, Stock.new(@product).stock_reserved

    one = @product.stock_transfer_rows.first.dup
    two = @product.stock_transfer_rows.first.dup

    # ST rows due to be picked today or in the past, should reserve stock (picked or not picked)
    one.update!(kerayspvm: Date.current, varattu: 10, keratty: '')
    two.update!(kerayspvm: Date.current, varattu: 10, keratty: 'joe')
    assert_equal 20, Stock.new(@product).stock_reserved

    # ST rows due to be picked in the future, should not affect reserve stock, unless picked
    one.update!(kerayspvm: 1.day.from_now, varattu: 5,  keratty: '')
    two.update!(kerayspvm: 1.day.from_now, varattu: 15, keratty: 'joe')
    assert_equal 15, Stock.new(@product).stock_reserved
  end

  test 'manufacture composite rows product stock is reserved by pick date' do
    # set stock management by pick date
    @product.company.parameter.update!(saldo_kasittely: :stock_management_by_pick_date)
    assert_equal 0, Stock.new(@product).stock_reserved

    # MF composite rows due to be picked today or earlier, should decrease stock reservation
    @product.manufacture_composite_rows.first.update!(kerayspvm: Date.current, varattu: 10, keratty: '')
    assert_equal -10, Stock.new(@product).stock_reserved

    # MF composite rows due to be picked in the future, should not affect reserve stock
    @product.manufacture_composite_rows.first.update!(kerayspvm: 1.day.from_now, varattu: 10, keratty: '')
    assert_equal 0, Stock.new(@product).stock_reserved
  end

  test 'manufacture recursive composite_rows product stock is reserved by pick date' do
    # set stock management by pick date
    @product.company.parameter.update!(saldo_kasittely: :stock_management_by_pick_date)
    assert_equal 0, Stock.new(@product).stock_reserved

    # MF recursive composite rows due to be picked today or earlier, should decrease stock reservation
    @product.manufacture_recursive_composite_rows.first.update!(kerayspvm: Date.current, varattu: 10, keratty: '')
    assert_equal -10, Stock.new(@product).stock_reserved

    # MF recursive composite rows due to be picked in the future, should not reserve stock
    @product.manufacture_recursive_composite_rows.first.update!(kerayspvm: 1.day.from_now, varattu: 10, keratty: '')
    assert_equal 0, Stock.new(@product).stock_reserved
  end

  test 'purchase order rows product stock is reserved by pick date' do
    # set stock management by pick date
    @product.company.parameter.update!(saldo_kasittely: :stock_management_by_pick_date)
    assert_equal 0, Stock.new(@product).stock_reserved

    # PO rows due in today or earlier, should decrease stock reservation
    @product.purchase_order_rows.first.update!(toimaika: Date.current, varattu: 10)
    assert_equal -10, Stock.new(@product).stock_reserved

    # PO rows in the future, should not affect reserve stock
    @product.purchase_order_rows.first.update!(toimaika: 1.day.from_now, varattu: 10)
    assert_equal 0, Stock.new(@product.reload).stock_reserved
  end

  test 'product stock is reserved by pick date with future reservations' do
    # set stock management by pick date with future reservations
    # this uses same logic as stock_management_by_pick_date, so we don't need to test everything again
    # this returns the "worst case" stock reserve, se we'll never sell out our stock
    @product.company.parameter.update!(saldo_kasittely: :stock_management_by_pick_date_and_with_future_reservations)
    assert_equal 0, Stock.new(@product).stock_reserved

    one    = @product.stock_transfer_rows.first
    two    = @product.stock_transfer_rows.first.dup
    po_one = @product.purchase_order_rows.first

    # sell 100 day one, we have 100 reserved no matter what date
    one.update!(varattu: 100, kerayspvm: 1.day.from_now)
    assert_equal 100, Stock.new(@product, stock_date: 1.day.ago).stock_reserved
    assert_equal 100, Stock.new(@product).stock_reserved
    assert_equal 100, Stock.new(@product, stock_date: 1.day.from_now).stock_reserved
    assert_equal 100, Stock.new(@product, stock_date: 2.days.from_now).stock_reserved
    assert_equal 100, Stock.new(@product, stock_date: 3.days.from_now).stock_reserved
    assert_equal 100, Stock.new(@product, stock_date: 9.days.from_now).stock_reserved

    # purchase 60 day three, we have 100 reserved before purchase, and 40 after
    po_one.update!(varattu: 60, toimaika: 3.days.from_now)
    assert_equal 100, Stock.new(@product, stock_date: 1.day.ago).stock_reserved
    assert_equal 100, Stock.new(@product).stock_reserved
    assert_equal 100, Stock.new(@product, stock_date: 1.day.from_now).stock_reserved
    assert_equal 100, Stock.new(@product, stock_date: 2.days.from_now).stock_reserved
    assert_equal 40,  Stock.new(@product, stock_date: 3.days.from_now).stock_reserved
    assert_equal 40,  Stock.new(@product, stock_date: 9.days.from_now).stock_reserved

    # sell 30 day five, we have 100 reserved before puchase, and 70 after
    two.update!(varattu: 30, kerayspvm: 5.days.from_now)
    assert_equal 100, Stock.new(@product, stock_date: 1.day.ago).stock_reserved
    assert_equal 100, Stock.new(@product).stock_reserved
    assert_equal 100, Stock.new(@product, stock_date: 1.day.from_now).stock_reserved
    assert_equal 100, Stock.new(@product, stock_date: 2.days.from_now).stock_reserved
    assert_equal 70,  Stock.new(@product, stock_date: 3.days.from_now).stock_reserved
    assert_equal 70,  Stock.new(@product, stock_date: 9.days.from_now).stock_reserved
  end
end
