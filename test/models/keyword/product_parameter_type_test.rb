require 'test_helper'

class Keyword::ProductParameterTypeTest < ActiveSupport::TestCase
  fixtures %w(
    keyword/product_parameter_types
  )

  setup do
    @keyword = keyword_product_parameter_types :color
  end

  test 'fixtures are valid' do
    assert @keyword.valid?
  end
end
