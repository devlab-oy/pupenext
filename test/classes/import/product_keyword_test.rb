require 'test_helper'

class Import::ProductKeywordTest < ActiveSupport::TestCase
  include SpreadsheetsHelper

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
    @helmet = products :helmet
    @hammer = products :hammer

    Product::Keyword.delete_all
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

  test 'imports keywords and returns response' do
    keywords = Import::ProductKeyword.new company_id: @company, user_id: @user, filename: @filename

    assert_difference 'Product::Keyword.count', 3 do
      response = keywords.import
      assert_equal Import::Response, response.class
    end
  end

  test 'toiminto values' do
    spreadsheet = create_xlsx([
      ['tuOTEno',            'laJI',    'selite', 'toiminTO'      ],
      ["#{@helmet.tuoteno}", 'nimitys', 'foo',    'LISAA'         ],
      ["#{@hammer.tuoteno}", 'nimitys', 'bar 1',  'LISÄÄ'         ],
      ["#{@hammer.tuoteno}", 'nimitys', 'bar 2',  'muoKKAa'       ],
      ["#{@hammer.tuoteno}", 'kuvaus',  'bar 2',  'muokkaa/lisää' ],
      ["#{@hammer.tuoteno}", 'kuvaus',  'bar 3',  'muokkaa/lisää' ],
      ["#{@helmet.tuoteno}", 'kuvaus',  'foo',    'LISAA'         ],
      ["#{@helmet.tuoteno}", 'kuvaus',  'foo',    'POISTA'        ],
    ])

    keywords = Import::ProductKeyword.new company_id: @company, user_id: @user, filename: spreadsheet

    assert_difference 'Product::Keyword.count', 3 do
      response = keywords.import
      assert response.rows.all? { |row| row.errors.empty? }, response.rows.map(&:errors)
    end

    assert_equal 'foo',   @helmet.keywords.first.selite
    assert_equal 'bar 2', @hammer.keywords.first.selite
    assert_equal 'bar 3', @hammer.keywords.last.selite
  end

  test 'adding duplicate fails' do
    spreadsheet = create_xlsx([
      ['tuoteno',            'laji',    'selite', 'toiminto'],
      ["#{@helmet.tuoteno}", 'nimitys', 'foo',    'LISAA'   ],
    ])

    keywords = Import::ProductKeyword.new company_id: @company, user_id: @user, filename: spreadsheet

    assert_difference 'Product::Keyword.count', 1 do
      keywords.import
    end

    keywords = Import::ProductKeyword.new company_id: @company, user_id: @user, filename: spreadsheet

    assert_no_difference 'Product::Keyword.count' do
      response = keywords.import
      assert_equal 'Laji on jo käytössä', response.rows.first.errors.first
    end
  end

  test 'adding with required fields missing fail' do
    spreadsheet = create_xlsx([
      ['tuoteno',            'selite', 'toiminto'],
      ["#{@helmet.tuoteno}", 'foo',    'LISAA'   ],
    ])

    keywords = Import::ProductKeyword.new company_id: @company, user_id: @user, filename: spreadsheet

    assert_no_difference 'Product::Keyword.count' do
      response = keywords.import
      assert_equal 'Laji ei löydy listasta', response.rows.first.errors.first
    end

    spreadsheet = create_xlsx([
      ['laji',    'selite', 'toiminto'],
      ['nimitys', 'foo',    'LISAA'   ],
    ])

    keywords = Import::ProductKeyword.new company_id: @company, user_id: @user, filename: spreadsheet

    assert_no_difference 'Product::Keyword.count' do
      response = keywords.import
      error = I18n.t('errors.import.product_not_found', product: '')
      assert_equal error, response.rows.first.errors.first
    end
  end

  test 'modifying with required fields fail' do
    spreadsheet = create_xlsx([
      ['tuoteno',           'laji',    'selite', 'toiminto'],
      ["#{@helmet.tuoteno}", 'nimitys', 'foo',   'LISAA'   ],
    ])

    keywords = Import::ProductKeyword.new company_id: @company, user_id: @user, filename: spreadsheet
    assert keywords.import

    spreadsheet = create_xlsx([
      ['tuoteno',            'selite', 'toiminto'],
      ["#{@helmet.tuoteno}", 'foo',    'muokkaa' ],
    ])

    keywords = Import::ProductKeyword.new company_id: @company, user_id: @user, filename: spreadsheet
    result = keywords.import

    error = I18n.t('errors.import.keyword_not_found', keyword: '', language: 'fi')
    assert_equal error, result.rows.first.errors.first
  end

  test 'errors are correct' do
    # Let's store one correct keyword
    spreadsheet = create_xlsx([
      ['tuoteno',            'laji',    'selite', 'toiminto'],
      ["#{@hammer.tuoteno}", 'nimitys', 'foo',    'lisää' ],
    ])

    keywords = Import::ProductKeyword.new company_id: @company, user_id: @user, filename: spreadsheet
    result = keywords.import
    assert_equal 0, result.rows.first.errors.count

    # Try adding with incorrect product
    spreadsheet = create_xlsx([
      ['tuoteno',     'selite', 'toiminto'],
      ["not_correct", 'foo',    'lisää' ],
    ])

    # We get only one error
    keywords = Import::ProductKeyword.new company_id: @company, user_id: @user, filename: spreadsheet
    result = keywords.import
    assert_equal 1, result.rows.first.errors.count
    error = I18n.t('errors.import.product_not_found', product: 'not_correct')
    assert_equal error, result.rows.first.errors.first

    # Correct product, but missing required fields
    spreadsheet = create_xlsx([
      ['tuoteno',            'selite', 'toiminto'],
      ["#{@hammer.tuoteno}", 'foo',    'muokkaa' ],
    ])

    # We get only one error
    keywords = Import::ProductKeyword.new company_id: @company, user_id: @user, filename: spreadsheet
    result = keywords.import
    assert_equal 1, result.rows.first.errors.count
    error = I18n.t('errors.import.keyword_not_found', keyword: '', language: 'fi')
    assert_equal error, result.rows.first.errors.first

    # Now we add required field, but laji already taken, and we'll get only one error
    spreadsheet = create_xlsx([
      ['tuoteno',            'laji',    'selite', 'toiminto'],
      ["#{@hammer.tuoteno}", 'nimitys', 'foo',    'lisää' ],
    ])

    keywords = Import::ProductKeyword.new company_id: @company, user_id: @user, filename: spreadsheet
    result = keywords.import
    assert_equal 1, result.rows.first.errors.count
    assert_equal 'Laji on jo käytössä', result.rows.first.errors.first
  end

  test 'adding completely wrong columns' do
    spreadsheet = create_xlsx([
      ['tuoteno',            'foo', 'bar', 'baz', 'toiminto'],
      ["#{@hammer.tuoteno}", '1',   '2',   '3',   'lisää'   ],
    ])

    keywords = Import::ProductKeyword.new company_id: @company, user_id: @user, filename: spreadsheet
    result = keywords.import

    assert_equal 1, result.rows.count
    assert_equal "Virheellinen sarake foo, bar ja baz!", result.rows.first.errors.first
  end

  test 'toiminto is required field' do
    # correct row, but toiminto column is missing
    spreadsheet = create_xlsx([
      ['tuoteno',            'laji',    'selite'],
      ["#{@hammer.tuoteno}", 'nimitys', 'foo',  ],
    ])

    keywords = Import::ProductKeyword.new company_id: @company, user_id: @user, filename: spreadsheet
    result = keywords.import
    assert_equal 1, result.rows.first.errors.count
    assert_equal I18n.t('errors.import.action_missing'), result.rows.first.errors.first

    # correct row, but toiminto column is incorrect
    spreadsheet = create_xlsx([
      ['tuoteno',            'laji',    'selite', 'toiminto'],
      ["#{@hammer.tuoteno}", 'nimitys', 'foo',    'bar'     ],
    ])

    keywords = Import::ProductKeyword.new company_id: @company, user_id: @user, filename: spreadsheet
    result = keywords.import
    assert_equal 1, result.rows.first.errors.count
    assert_equal I18n.t('errors.import.action_incorrect'), result.rows.first.errors.first
  end
end
