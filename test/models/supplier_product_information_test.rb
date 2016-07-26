require 'test_helper'

class SupplierProductInformationTest < ActiveSupport::TestCase
  fixtures %w(
    category/links
    category/products
    products
    supplier_product_informations
    suppliers
  )

  setup do
    @one = supplier_product_informations(:one)
    @two = supplier_product_informations(:two)

    @hammer = products(:hammer)

    @reliable_supplier = suppliers(:reliable_supplier)
    @domestic_supplier = suppliers(:domestic_supplier)
  end

  test 'fixtures are valid' do
    assert @one.valid?, @one.errors.full_messages
    assert @two.valid?, @two.errors.full_messages
  end

  test 'product association works' do
    assert_equal @hammer, @one.product
    assert_nil @two.product
  end

  test 'supplier association works' do
    assert_equal @reliable_supplier, @one.supplier
    assert_equal @domestic_supplier, @two.supplier
  end

  test 'dynamic_tree_association works' do
    assert_equal category_products(:product_category_shirts), @one.product_category
  end

  test 'searching works' do
    search_result = SupplierProductInformation.search_like(product_name: 'ramb')

    assert_includes search_result, @one
    assert_not_includes search_result, @two
  end
end
