require 'test_helper'

class SupplierProductInformationTest < ActiveSupport::TestCase
  fixtures %w(
    products
    supplier_product_informations
  )

  setup do
    @one = supplier_product_informations(:one)
    @two = supplier_product_informations(:two)

    @hammer = products(:hammer)
  end

  test 'fixtures are valid' do
    assert @one.valid?, @one.errors.full_messages
    assert @two.valid?, @two.errors.full_messages
  end

  test 'product association works' do
    assert_equal @hammer, @one.product
    assert_nil @two.product
  end

  test 'searching works' do
    search_result = SupplierProductInformation.search_like({ product_name: 'ramb' })

    assert_includes search_result, @one
    assert_not_includes search_result, @two
  end
end
