require 'test_helper'
require 'minitest/mock'

class ProductTest < ActiveSupport::TestCase
  fixtures %w(
    attachment/product_attachments
    category/links
    category/products
    customer_prices
    customers
    keyword/customer_subcategories
    keywords
    manufacture_order/composite_rows
    manufacture_order/recursive_composite_rows
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
    assert @product_image.valid?
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
    assert @product.attachments.count > 0
    assert @product.customer_prices.count > 0
    assert @product.customers.count > 0
    assert_includes @product.product_links, category_links(:product_category_shirts_hammer)
    assert_includes @product.product_categories, category_products(:product_category_shirts)
  end

  test 'stock_transfer_rows product stock reserved by pick date' do
    # set stock management by pick date
    @product.company.parameter.update! saldo_kasittely: :stock_management_by_pick_date
    assert_equal 0, @product.stock_reserved

    one = @product.stock_transfer_rows.first.dup
    two = @product.stock_transfer_rows.first.dup

    # ST rows due to be picked today or in the past, should reserve stock (picked or not picked)
    one.update! kerayspvm: Date.today, varattu: 10, keratty: ''
    two.update! kerayspvm: Date.today, varattu: 10, keratty: 'joe'
    assert_equal 20, @product.stock_reserved

    # ST rows due to be picked in the future, should not affect reserve stock, unless picked
    one.update! kerayspvm: 1.day.from_now, varattu: 5,  keratty: ''
    two.update! kerayspvm: 1.day.from_now, varattu: 15, keratty: 'joe'
    assert_equal 15, @product.stock_reserved
  end

  test 'manufacture_composite_rows product stock reserved by pick date' do
    # set stock management by pick date
    @product.company.parameter.update! saldo_kasittely: :stock_management_by_pick_date
    assert_equal 0, @product.stock_reserved

    # MF composite rows due to be picked today or earlier, should decrease stock reservation
    @product.manufacture_composite_rows.first.update! kerayspvm: Date.today, varattu: 10, keratty: ''
    assert_equal -10, @product.stock_reserved

    # MF composite rows due to be picked in the future, should not affect reserve stock
    @product.manufacture_composite_rows.first.update! kerayspvm: 1.day.from_now, varattu: 10, keratty: ''
    assert_equal 0, @product.stock_reserved
  end

  test 'manufacture_recursive_composite_rows product stock reserved by pick date' do
    # set stock management by pick date
    @product.company.parameter.update! saldo_kasittely: :stock_management_by_pick_date
    assert_equal 0, @product.stock_reserved

    # MF recursive composite rows due to be picked today or earlier, should decrease stock reservation
    @product.manufacture_recursive_composite_rows.first.update! kerayspvm: Date.today, varattu: 10, keratty: ''
    assert_equal -10, @product.stock_reserved

    # MF recursive composite rows due to be picked in the future, should not reserve stock
    @product.manufacture_recursive_composite_rows.first.update! kerayspvm: 1.day.from_now, varattu: 10, keratty: ''
    assert_equal 0, @product.stock_reserved
  end

  test 'purchase_order_rows product stock reserved by pick date' do
    # set stock management by pick date
    @product.company.parameter.update! saldo_kasittely: :stock_management_by_pick_date
    assert_equal 0, @product.stock_reserved

    # PO rows due in today or earlier, should decrease stock reservation
    @product.purchase_order_rows.first.update! toimaika: Date.today, varattu: 10
    assert_equal -10, @product.stock_reserved

    # PO rows in the future, should not affect reserve stock
    @product.purchase_order_rows.first.update! toimaika: 1.day.from_now, varattu: 10
    assert_equal 0, @product.reload.stock_reserved
  end

  test 'product stock reserved by pick date with future reservations' do
    # set stock management by pick date with future reservations
    # this uses same logic as stock_management_by_pick_date, so we don't need to test everything again
    # this returns the "worst case" stock reserve, se we'll never sell out our stock
    @product.company.parameter.update! saldo_kasittely: :stock_management_by_pick_date_and_with_future_reservations
    assert_equal 0, @product.stock_reserved

    one = @product.stock_transfer_rows.first
    two = @product.stock_transfer_rows.first.dup
    po_one = @product.purchase_order_rows.first

    # sell 100 day one, we have 100 reserved no matter what date
    one.update! varattu: 100, kerayspvm: 1.day.from_now
    assert_equal 100, @product.stock_reserved(stock_date: 1.day.ago)
    assert_equal 100, @product.stock_reserved
    assert_equal 100, @product.stock_reserved(stock_date: 1.day.from_now)
    assert_equal 100, @product.stock_reserved(stock_date: 2.day.from_now)
    assert_equal 100, @product.stock_reserved(stock_date: 3.day.from_now)
    assert_equal 100, @product.stock_reserved(stock_date: 9.day.from_now)

    # purchase 60 day three, we have 100 reserved before purchase, and 40 after
    po_one.update! varattu: 60, toimaika: 3.day.from_now
    assert_equal 100, @product.stock_reserved(stock_date: 1.day.ago)
    assert_equal 100, @product.stock_reserved
    assert_equal 100, @product.stock_reserved(stock_date: 1.day.from_now)
    assert_equal 100, @product.stock_reserved(stock_date: 2.day.from_now)
    assert_equal 40,  @product.stock_reserved(stock_date: 3.day.from_now)
    assert_equal 40,  @product.stock_reserved(stock_date: 9.day.from_now)

    # sell 30 day five, we have 100 reserved before puchase, and 70 after
    two.update! varattu: 30, kerayspvm: 5.day.from_now
    assert_equal 100, @product.stock_reserved(stock_date: 1.day.ago)
    assert_equal 100, @product.stock_reserved
    assert_equal 100, @product.stock_reserved(stock_date: 1.day.from_now)
    assert_equal 100, @product.stock_reserved(stock_date: 2.day.from_now)
    assert_equal 70,  @product.stock_reserved(stock_date: 3.day.from_now)
    assert_equal 70,  @product.stock_reserved(stock_date: 9.day.from_now)
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

  test 'customer price with info' do
    customer = customers(:stubborn_customer)
    price    = { hinta: 18, hinta_peruste: 1, ale_peruste: 2 }

    LegacyMethods.stub(:customer_price_with_info, price) do
      assert_equal price, @product.customer_price_with_info(customer.id)
    end
  end

  test 'customer subcategory price' do
    customer = customers(:stubborn_customer)

    LegacyMethods.stub(:customer_subcategory_price, 22) do
      assert_equal 22, @product.customer_subcategory_price(customer.id)
    end
  end

  test 'customer subcategory price with info' do
    customer = customers(:stubborn_customer)
    price    = { hinta: 18, hinta_peruste: 1, ale_peruste: 2 }

    LegacyMethods.stub(:customer_subcategory_price_with_info, price) do
      assert_equal price, @product.customer_subcategory_price_with_info(customer.id)
    end
  end

  test 'cover image' do
    assert_equal @product_image, @product.cover_image

    Attachment.delete_all

    assert_nil @product.reload.cover_image
  end

  test 'delegated methods' do
    assert_equal @product.attachments.images, @product.images
    assert_equal @product.attachments.thumbnails, @product.thumbnails
  end

  test 'contract_price?' do
    contract_price       = { hinta: 18, hinta_peruste: 12, ale_peruste: 6, contract_price: true }
    non_contract_price   = { hinta: 18, hinta_peruste: 18, ale_peruste: 13, contract_price: false }
    customer             = customers(:stubborn_customer)
    customer_subcategory = keyword_customer_subcategories(:customer_subcategory_1)

    LegacyMethods.stub(:customer_price_with_info, contract_price) do
      assert_equal true, @product.contract_price?(customer)
    end

    LegacyMethods.stub(:customer_subcategory_price_with_info, contract_price) do
      assert_equal true, @product.contract_price?(customer_subcategory)
    end

    LegacyMethods.stub(:customer_price_with_info, non_contract_price) do
      assert_equal false, @product.contract_price?(customer)
    end

    LegacyMethods.stub(:customer_subcategory_price_with_info, non_contract_price) do
      assert_equal false, @product.contract_price?(customer_subcategory)
    end

    assert_equal false, @product.contract_price?('kissa')
  end
end
