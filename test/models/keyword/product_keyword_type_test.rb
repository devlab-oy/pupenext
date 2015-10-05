require 'test_helper'

class Keyword::ProductKeywordTypeTest < ActiveSupport::TestCase
  fixtures %w(
    keyword/product_keyword_types
  )

  setup do
    @keyword = keyword_product_keyword_types :one
  end

  test 'fixtures are valid' do
    assert @keyword.valid?
  end
end
