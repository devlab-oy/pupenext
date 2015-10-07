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
    @user = users(:joe).id
    @company = users(:joe).company.id
  end

  test 'initialize' do
    rails_upload = Rack::Test::UploadedFile.new @filename
    wrong_format = Rails.root.join 'test', 'fixtures', 'companies.yml'

    assert Import::ProductKeyword.new company_id: @company, user_id: @user, filename: @filename
    assert Import::ProductKeyword.new company_id: @company, user_id: @user, filename: rails_upload
    assert_raises { Import::ProductKeyword.new company_id: @company, user_id: @user, filename: nil }
    assert_raises { Import::ProductKeyword.new company_id: @company, user_id: @user, filename: 'not_found.xls' }
    assert_raises { Import::ProductKeyword.new company_id: @company, user_id: @user, filename: wrong_format }
  end

  test 'imports keywords' do
    keywords = Import::ProductKeyword.new company_id: @company, user_id: @user, filename: @filename
    Product::Keyword.delete_all

    assert_difference 'Product::Keyword.count', 3 do
      response = keywords.import
      assert_equal Import::Response, response.class
    end
  end
end
