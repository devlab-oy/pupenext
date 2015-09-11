require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures %w(products keywords product/suppliers pending_updates)

  setup do
    @product = products :hammer
  end

  test 'all fixtures should be valid' do
    assert @product.valid?
  end

  test 'relations' do
    group = keywords :group_tools
    assert_equal group.description, @product.group.description

    status = keywords :status_active
    assert_equal status.description, @product.status.description

    product_supplier = product_suppliers :domestic_product_supplier
    assert_equal @product.tuoteno, product_supplier.product.tuoteno

    assert_equal @product.id, @product.pending_updates.first.pending_updatable_id
  end
end
