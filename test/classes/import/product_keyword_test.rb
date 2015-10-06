require 'test_helper'

class Import::ProductKeywordTest < ActiveSupport::TestCase
  fixtures %w(
    keyword/product_information_types
    keyword/product_keyword_types
    keyword/product_parameter_types
    product/keywords
    products
  )

  setup do
    @filename = Rails.root.join 'test', 'fixtures', 'files', 'product_keyword_test.xlsx'
  end

  test 'initialize' do
    rails_upload = Rack::Test::UploadedFile.new @filename
    wrong_format = Rails.root.join 'test', 'fixtures', 'companies.yml'

    assert Import::ProductKeyword.new @filename
    assert Import::ProductKeyword.new rails_upload
    assert_raises { Import::ProductKeyword.new }
    assert_raises { Import::ProductKeyword.new nil }
    assert_raises { Import::ProductKeyword.new 'not_found_file.xls' }
    assert_raises { Import::ProductKeyword.new wrong_format }
  end

  test 'first row contains column labels' do
    keywords = Import::ProductKeyword.new(@filename)
    Product::Keyword.delete_all

    assert_difference 'Product::Keyword.count', 3 do
      keywords.import
    end
  end
end
