require 'test_helper'
require 'minitest/mock'

class ProductTest < ActiveSupport::TestCase
  fixtures %w(
    attachment/product_attachments
    customer_prices
    customers
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
    @product_image = attachment_product_attachments(:product_image_2)
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
    assert @product.keywords.count > 0
    assert @product.manufacture_rows.count > 0
    assert @product.pending_updates.count > 0
    assert @product.product_suppliers.count > 0
    assert @product.purchase_order_rows.count > 0
    assert @product.sales_order_rows.count > 0
    assert @product.shelf_locations.count > 0
    assert @product.stock_transfer_rows.count > 0
    assert @product.suppliers.count > 0
    assert @product.attachments.count > 0
    assert @product.customer_prices.count > 0
    assert @product.customers.count > 0
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

  test 'product reserved stock' do
    # these rows should affect reserved stock, let's zero them out
    @product.sales_order_rows.update_all(varattu: 0)
    @product.manufacture_rows.update_all(varattu: 0)
    @product.stock_transfer_rows.update_all(varattu: 0)
    assert_equal 0, @product.stock_reserved

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

    assert_equal 2, company.products.active.count
    assert_not_equal 2, company.products.count
  end

  test 'customer price' do
    customer = customers(:stubborn_customer)

    LegacyMethods.stub(:customer_price, 18) do
      assert_equal 18, @product.customer_price(customer.id)
    end
  end

  test 'customer subcategory price' do
    customer = customers(:stubborn_customer)

    LegacyMethods.stub(:customer_subcategory_price, 22) do
      assert_equal 22, @product.customer_subcategory_price(customer.id)
    end
  end

  test 'cover image' do
    assert_equal @product_image, @product.cover_image

    Attachment.delete_all

    assert_nil @product.cover_image
  end

  test 'delegated methods' do
    assert_equal @product.attachments.images, @product.images
    assert_equal @product.attachments.thumbnails, @product.thumbnails
  end
end
