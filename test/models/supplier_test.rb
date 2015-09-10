require 'test_helper'

class SupplierTest < ActiveSupport::TestCase
  fixtures %w(suppliers)

  setup do
    @supplier = suppliers :domestic_supplier
  end

  test 'all fixtures should be valid' do
    assert @supplier.valid?
  end
end
