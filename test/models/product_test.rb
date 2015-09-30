require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures %w(
    keywords
    manufacture_order/rows
    pending_updates
    product/suppliers
    products
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
    category = keywords :category_tools
    assert_equal category.description, @product.category.description

    subcategory = keywords :subcategory_tools
    assert_equal subcategory.description, @product.subcategory.description

    brand = keywords :brand_tools
    assert_equal brand.name, @product.brand.name

    status = keywords :status_active
    assert_equal status.description, @product.status.description

    product_supplier = product_suppliers :domestic_product_supplier
    assert_equal @product.tuoteno, product_supplier.product.tuoteno

    supplier = suppliers :domestic_supplier
    assert_equal supplier.nimi, @product.suppliers.first.nimi

    assert_equal @product.id, @product.pending_updates.first.pending_updatable_id

    assert_equal 'OSASTO', @product.category.laji
    assert_equal 'TRY', @product.subcategory.laji
    assert_equal 'TUOTEMERKKI', @product.brand.laji
    assert_equal 'S', @product.status.laji
    assert @product.product_suppliers.count > 0
    assert @product.suppliers.count > 0
    assert @product.pending_updates.count > 0
    assert @product.shelf_locations.count > 0
    assert @product.manufacture_rows.count > 0
    assert @product.stock_transfer_rows.count > 0
  end

  test 'scopes' do
    company = @product.company

    assert_not_equal 0, company.products.normal.count
    assert_not_equal 0, company.products.viranomaistuotteet.count
    assert_not_equal 0, company.products.active.count
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
end
