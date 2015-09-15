require 'test_helper'

class Product::SupplierTest < ActiveSupport::TestCase
  fixtures %w(products suppliers product/suppliers)

  setup do
    @product_supplier = product_suppliers :domestic_product_supplier
    @product = products :hammer
    @supplier = suppliers :domestic_supplier
  end

  test 'all fixtures should be valid' do
    assert @product_supplier.valid?
    assert @product.valid?
    assert @supplier.valid?
  end

  test 'relations' do
    assert_equal @product.tuoteno, @product_supplier.product.tuoteno
    assert_equal @supplier.nimi, @product_supplier.supplier.nimi
  end
end
