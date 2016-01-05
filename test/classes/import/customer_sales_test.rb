require 'test_helper'

class Import::CustomerSalesTest < ActiveSupport::TestCase
  include SpreadsheetsHelper

  fixtures %w(
    products
    customers
  )

  setup do
    @user = users(:joe).id
    @company = users(:joe).company.id

    @helmet = products :helmet
    @helmet.tuoteno = '12345'
    @helmet.save

    @hammer = products :hammer
    @hammer.tuoteno = '67890'
    @hammer.save

    @customer = customers :stubborn_customer

    @filename = create_xlsx([
      ['Tuote/Asiakas',                                           'Kpl', 'Myynti EUR' ],
      ['Yhteensä',                                                '',    123000       ],
      ["#{@helmet.tuoteno} #{@helmet.osasto} #{@helmet.nimitys}", '',    23000        ],
      ["#{@customer.asiakasnro} #{@customer.nimi}",               10,    23000        ],
      ["#{@hammer.tuoteno} #{@hammer.osasto} #{@hammer.nimitys}", '',    100000       ],
      ["#{@customer.asiakasnro} #{@customer.nimi}",               23,    100000       ],
      ['Yhteensä',                                                '',    123000       ],
    ])
  end

  test 'imports sales and returns response' do
    sales = Import::CustomerSales.new company_id: @company, user_id: @user, filename: @filename

    # assert_difference 'Product::Keyword.count', 3 do
      response = sales.import
      assert_equal Import::Response, response.class
    # end
  end

  test 'adding with invalid data should fail' do
    filename = create_xlsx([
      ['Tuote/Asiakas',                            'Kpl', 'Myynti EUR' ],
      ['Yhteensä',                                 '',    123000       ],
      ["999 #{@helmet.osasto} #{@helmet.nimitys}", '',    23000        ],
      ["666 #{@customer.nimi}",                    10,    23000        ],
      ['Yhteensä',                                 '',    123000       ],
    ])

    sales = Import::CustomerSales.new company_id: @company, user_id: @user, filename: filename

    response = sales.import
    assert_equal 'Tuotetta "999" ei löytynyt!', response.rows.first.errors.first
    assert_equal 'Asiakasta "666" ei löytynyt!', response.rows.second.errors.first
  end

  test 'errors are correct' do
    # Let's store one correct product and customer
    filename = create_xlsx([
      ['Tuote/Asiakas',                                           'Kpl', 'Myynti EUR' ],
      ['Yhteensä',                                                '',    123000       ],
      ["#{@helmet.tuoteno} #{@helmet.osasto} #{@helmet.nimitys}", '',    23000        ],
      ["#{@customer.asiakasnro} #{@customer.nimi}",               10,    23000        ],
    ])

    sales = Import::CustomerSales.new company_id: @company, user_id: @user, filename: filename
    result = sales.import
    assert_equal 0, result.rows.first.errors.count

    # Try adding with incorrect product
    filename = create_xlsx([
      ['Tuote/Asiakas',                            'Kpl', 'Myynti EUR' ],
      ['Yhteensä',                                 '',    123000       ],
      ["666 #{@helmet.osasto} #{@helmet.nimitys}", '',    23000        ],
    ])

    # We get only one error
    sales = Import::CustomerSales.new company_id: @company, user_id: @user, filename: filename
    result = sales.import
    assert_equal 1, result.rows.first.errors.count
    error = I18n.t('errors.import.product_not_found', product: '666')
    assert_equal error, result.rows.first.errors.first

    # Try adding with incorrect customer
    filename = create_xlsx([
      ['Tuote/Asiakas',                                           'Kpl', 'Myynti EUR' ],
      ['Yhteensä',                                                '',    123000       ],
      ["#{@helmet.tuoteno} #{@helmet.osasto} #{@helmet.nimitys}", '',    23000        ],
      ["999 #{@customer.nimi}",                                   10,    23000        ],
    ])

    # We get only one error
    sales = Import::CustomerSales.new company_id: @company, user_id: @user, filename: filename
    result = sales.import
    assert_equal 1, result.rows.second.errors.count
    error = I18n.t('errors.import.customer_not_found', customer: '999')
    assert_equal error, result.rows.second.errors.first
  end
end
