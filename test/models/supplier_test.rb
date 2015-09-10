require 'test_helper'

class SupplierTest < ActiveSupport::TestCase
  fixtures %w(suppliers product/suppliers)

  setup do
    @supplier = suppliers :domestic_supplier
  end

  test 'all fixtures should be valid' do
    assert @supplier.valid?
  end

  test 'relations' do
    product_supplier = product_suppliers :domestic_product_supplier
    assert_equal @supplier.nimi, product_supplier.supplier.nimi
  end
end
