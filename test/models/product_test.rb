require 'test_helper'
require 'minitest/mock'

class ProductTest < ActiveSupport::TestCase
  fixtures %w(
    customers
    keywords
    manufacture_order/rows
    pending_updates
    product/keywords
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
    assert @product.keywords.count > 0
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
    assert_equal 0, @product.stock_reserved

    brand = keywords :brand_tools
    assert_equal brand.name, @product.brand.name

    @product.sales_order_rows.first.update!(varattu: 10)
    assert_equal 10, @product.stock_reserved

    @product.manufacture_rows.first.update!(varattu: 5)
    assert_equal 15, @product.stock_reserved

    @product.stock_transfer_rows.first.update!(varattu: 6)
    assert_equal 21, @product.stock_reserved
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

  test 'active scope' do
    # make all inactive
    company = @product.company
    company.products.update_all(status: 'P')

    # activate two
    two = @product.dup.update!(tuoteno: 'foo')
    three = @product.dup.update!(tuoteno: 'bar')
    four = @product.dup.update!(tuoteno: 'viranomaistuote XX', tuotetyyppi: 'A')

    assert_equal 2, company.products.active.count
    assert_not_equal 2, company.products.count

    assert_not_equal 0, company.products.normal.count
    assert_equal 1, company.products.viranomaistuotteet.count
  end

  test 'customer price' do
    customer = customers(:stubborn_customer)

    LegacyMethods.stub(:customer_price, 18) do
      assert_equal 18, @product.customer_price(customer.id)
    end
  end
end
