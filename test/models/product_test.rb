require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures %w(products keywords product/suppliers pending_updates suppliers head/sales_invoice_rows)

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
    assert_equal brand.tag, @product.brand.tag

    status = keywords :status_active
    assert_equal status.description, @product.status.description

    product_supplier = product_suppliers :domestic_product_supplier
    assert_equal @product.tuoteno, product_supplier.product.tuoteno

    supplier = suppliers :domestic_supplier
    assert_equal supplier.nimi, @product.suppliers.first.nimi

    assert_equal @product.id, @product.pending_updates.first.pending_updatable_id

    assert_not_equal 0, @product.sales_invoice_rows.count
  end
end
