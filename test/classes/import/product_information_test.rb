require 'test_helper'

class Import::ProductInformationTest < ActiveSupport::TestCase
  include SpreadsheetsHelper

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

    file = Rails.root.join 'test', 'fixtures', 'files', 'product_keyword_information_test.xlsx'

    @arguments = {
      company_id: @company,
      user_id: @user,
      filename: file,
      language: 'fi',
      type: 'information',
    }
  end

  test 'initialize' do
    assert Import::ProductInformation.new(@arguments)
  end

  test 'imports example file' do
    # adding 2, removing 1
    array = [
      ['tuoTENo',     'Tuotteen mateRIAali', 'Tuotteen KOKO', 'PoIsta'],
      ['hammer123',   'Aluminium',           'XL',            ''      ],
      ['ski1',        'Hiilikuitu',          'small',         ''      ],
      ['hammer123',   'Aluminium',           '',              'X'     ],
    ]

    @arguments[:filename] = create_xlsx(array)

    # Test Import::Base methods here (TODO: this is wrong place)
    importer = Import::ProductInformation.new(@arguments)

    # header row should be first row as is (notice case)
    assert_equal array.first, importer.send(:header_row)

    # row to hash should downcase header row and return hash with values
    response = {
      "tuoteno"             => "hammer123",
      "tuotteen materiaali" => "Aluminium",
      "tuotteen koko"       => "XL",
      "poista"              => ""
    }
    assert_equal response, importer.send(:row_to_hash, array.second)

    # type_hash should return all company keywords/information/parameters as a hash
    type_hash = importer.send(:type_hash)
    assert_equal "information", type_hash[:type]
    assert_equal "material", type_hash["tuotteen materiaali"].selite
    assert_equal "Tuotteen materiaali", type_hash["tuotteen materiaali"].selitetark

    assert_difference 'Product::Keyword.count', 2 do
      response = importer.import
      assert_equal Import::Response, response.class
    end
  end

  test 'row converts excel to fields for product information keyword' do
    # first row from the example file
    data = {
      "Tuoteno"             => "ski1",
      "Tuotteen materiaali" => "Villa",
      "Tuotteen koko"       => "XL",
      "Poista"              => nil,
    }

    # which should translate to product keywords like so
    keywords = [
      { tuoteno: 'ski1', laji: 'lisatieto_material', selite: 'Villa', kieli: 'fi', toiminto: 'MUOKKAA/LISÄÄ' },
      { tuoteno: 'ski1', laji: 'lisatieto_koko',     selite: 'XL',    kieli: 'fi', toiminto: 'MUOKKAA/LISÄÄ' }
    ]

    importer = Import::ProductInformation.new(@arguments)
    row = Import::ProductInformation::Row.new data, language: 'fi', type: importer.send(:type_hash)
    assert_equal keywords, row.values
  end

  test 'row converts excel to fields for product information parameter' do
    # first row from the example file
    data = {
      "Tuoteno"        => "ski1",
      "Tuotteen väri"  => "Sininen",
      "Malliston nimi" => "Summer",
      "Poista"         => nil,
    }

    # which should translate to product keywords like so
    keywords = [
      { tuoteno: 'ski1', laji: 'parametri_vari',     selite: 'Sininen', kieli: 'fi', toiminto: 'MUOKKAA/LISÄÄ' },
      { tuoteno: 'ski1', laji: 'parametri_mallisto', selite: 'Summer',  kieli: 'fi', toiminto: 'MUOKKAA/LISÄÄ' }
    ]

    @arguments[:type] = 'parameter'
    importer = Import::ProductInformation.new(@arguments)
    row = Import::ProductInformation::Row.new data, language: 'fi', type: importer.send(:type_hash)
    assert_equal keywords, row.values
  end

  test 'row converts removable rows correctly' do
    # first row from the example file
    data = {
      "Tuoteno"             => "ski1",
      "Tuotteen materiaali" => "Villa",
      "Tuotteen koko"       => "XL",
      "Poista"              => 'X',
    }

    # which should translate to product keywords like so
    keywords = [
      { tuoteno: 'ski1', laji: 'lisatieto_material', selite: 'Villa', kieli: 'fi', toiminto: 'POISTA' },
      { tuoteno: 'ski1', laji: 'lisatieto_koko',     selite: 'XL',    kieli: 'fi', toiminto: 'POISTA' }
    ]

    importer = Import::ProductInformation.new(@arguments)
    row = Import::ProductInformation::Row.new data, language: 'fi', type: importer.send(:type_hash)
    assert_equal keywords, row.values
  end
end
