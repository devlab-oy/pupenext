require 'test_helper'

class Import::ProductKeywordTest < ActiveSupport::TestCase
  setup do
    @filename = Rails.root.join 'test', 'fixtures', 'files', 'product_upload_test.xlsx'
  end

  test 'initialize' do
    wrong_format = Rails.root.join 'test', 'fixtures', 'companies.yml'

    assert Import::ProductKeyword.new @filename
    assert_raises { Import::ProductKeyword.new }
    assert_raises { Import::ProductKeyword.new nil }
    assert_raises { Import::ProductKeyword.new 'not_found_file.xls' }
    assert_raises { Import::ProductKeyword.new wrong_format }
  end
end
