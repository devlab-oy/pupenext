require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures %w(products keywords)

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
  end
end
