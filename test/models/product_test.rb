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
    manufacture_order/rows
    pending_updates
    product/keywords
    product/suppliers
    products
    purchase_order/rows
    sales_order/rows
    stock_transfer/rows
    suppliers
    warehouses
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
    assert @product.warehouses.count > 0
  end

  test 'valid status' do
    assert_equal 'A', @product.status

    @product.status = 'T'
    @product.save!
    assert @product.valid?

    @product.status = 'I'
    @product.save!
    assert @product.valid?
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
