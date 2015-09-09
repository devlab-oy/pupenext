require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures %w(products)

  setup do
    @product = products(:one)
  end

  test 'all fixtures should be valid' do
    assert @product.valid?
  end
end
