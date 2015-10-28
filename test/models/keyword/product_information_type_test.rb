require 'test_helper'

class Keyword::ProductInformationTypeTest < ActiveSupport::TestCase
  fixtures %w(
    keyword/product_information_types
  )

  setup do
    @keyword = keyword_product_information_types :material
  end

  test 'fixtures are valid' do
    assert @keyword.valid?
  end

  test 'product keyword' do
    assert_equal "LISATIETO_material", @keyword.product_key
  end
end
