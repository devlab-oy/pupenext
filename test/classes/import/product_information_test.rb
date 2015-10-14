require 'test_helper'

class Import::ProductInformationTest < ActiveSupport::TestCase
  fixtures %w(
    keyword/product_information_types
    keyword/product_keyword_types
    keyword/product_parameter_types
    product/keywords
    products
  )

  setup do
    joe      = users :joe
    @user    = joe.id
    @company = joe.company.id
    @helmet  = products :helmet
    @hammer  = products :hammer

    Product::Keyword.delete_all

    @info_file = Rails.root.join 'test', 'fixtures', 'files', 'product_keyword_information_test.xlsx'
    @param_file = Rails.root.join 'test', 'fixtures', 'files', 'product_keyword_parameter_test.xlsx'

    @arguments = {
      company_id: @company,
      user_id: @user,
      filename: @info_file,
      language: 'fi',
      type: 'information',
    }
  end

  test 'initialize' do
    assert Import::ProductInformation.new(@arguments)
  end

  test 'imports example file' do
    # adding 2, removing 1
    assert_difference 'Product::Keyword.count', 1 do
      response = Import::ProductInformation.new(@arguments).import
      assert_equal Import::Response, response.class
    end
  end

  test 'row converts excel to fields for product_keyword' do
    # first row from the example file
    data = {
      "Tuotenumero"         => "ski1",
      "Tuotteen materiaali" => "Sininen",
      "Tuotteen koko"       => "XL",
      "Poista"              => nil,
    }

    # which should translate to product keywords like so
    keywords = [
      { tuoteno: 'ski1', laji: 'material', selite: 'Sininen', kieli: 'fi', toiminto: 'MUOKKAA/LISÄÄ' },
      { tuoteno: 'ski1', laji: 'koko',     selite: 'XL',      kieli: 'fi', toiminto: 'MUOKKAA/LISÄÄ' }
    ]

    row = Import::ProductInformation::Row.new data, language: 'fi', type: 'information'
    assert_equal keywords, row.values
  end
end
