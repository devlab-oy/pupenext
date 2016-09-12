require 'test_helper'

class Product::StatusTest < ActiveSupport::TestCase
  fixtures %w(keywords products)

  setup do
    @status = keywords :status_made_up_random
  end

  test 'fixtures are valid' do
    assert @status.valid?
  end

  test 'relations' do
    product = products :rnd
    assert_equal @status.description, product.status.description
  end
end
