require 'test_helper'

class SupplierProductInformationTest < ActiveSupport::TestCase
  fixtures %w(
    supplier_product_informations
  )

  setup do
    @one = supplier_product_informations(:one)
    @two = supplier_product_informations(:two)
  end

  test 'fixtures are valid' do
    assert @one.valid?, @one.errors.full_messages
    assert @two.valid?, @two.errors.full_messages
  end
end
