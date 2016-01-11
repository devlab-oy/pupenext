require 'test_helper'

class Import::CustomerSalesTest < ActiveSupport::TestCase
  include SpreadsheetsHelper

  fixtures %w(
    customers
    products
    sales_order/detail_rows
    sales_order/details
  )

  setup do
    @user = users(:joe).id
    @company = users(:joe).company.id

    @helmet = products :helmet
    @helmet.update! tuoteno: '12345'

    @hammer = products :hammer
    @hammer.update! tuoteno: '67890'

    @customer = customers :stubborn_customer
    @lissu    = customers :lissu
  end

  test 'imports sales and returns response' do
    filename = create_xlsx([
      ['Tuote/Asiakas',                                           'Kpl', 'Myynti EUR' ],
      ['Yhteensä',                                                '',    123000       ],
      ["#{@customer.asiakasnro} #{@customer.nimi}",               '',    23000        ],
      ["#{@helmet.tuoteno} #{@helmet.osasto} #{@helmet.nimitys}", 10,    23000        ],
      ["#{@hammer.tuoteno} #{@hammer.osasto} #{@hammer.nimitys}", 23,    100000       ],
      ["#{@lissu.asiakasnro} #{@lissu.nimi}",                     '',    100000       ],
      ["#{@helmet.tuoteno} #{@helmet.osasto} #{@helmet.nimitys}", 10,    23000        ],
      ["#{@hammer.tuoteno} #{@hammer.osasto} #{@hammer.nimitys}", 23,    100000       ],
      ['Yhteensä',                                                '',    123000       ],
    ])

    params = {
      company_id: @company,
      user_id: @user,
      filename: filename,
      month: 1,
      year: 2016,
    }

    sales = Import::CustomerSales.new params

    assert_difference 'SalesOrder::Detail.count', 2 do
      response = sales.import
      assert_equal Import::Response, response.class
    end
  end

  test 'adding with invalid data should fail' do
    filename = create_xlsx([
      ['Tuote/Asiakas',                            'Kpl', 'Myynti EUR' ],
      ['Yhteensä',                                 '',    123000       ],
      ["666 #{@customer.nimi}",                    '',    23000        ],
      ["foobar",                                   '',    23000        ],
      ["999 #{@helmet.osasto} #{@helmet.nimitys}", 10,    23000        ],
      ["foobar",                                   10,    23000        ],
      ['Yhteensä',                                 '',    123000       ],
    ])

    params = {
      company_id: @company,
      user_id: @user,
      filename: filename,
      month: 1,
      year: 2016,
    }

    sales = Import::CustomerSales.new params

    assert_no_difference 'SalesOrder::Detail.count' do
      response = sales.import
      assert_equal 'Asiakasta "666" ei löytynyt!', response.rows.second.errors.first
      assert_equal 'Asiakasta "foobar" ei löytynyt!', response.rows.third.errors.first
      assert_equal 'Tuotetta "999" ei löytynyt!', response.rows.fourth.errors.first
      assert_equal 'Tuotetta "foobar" ei löytynyt!', response.rows.fifth.errors.first
    end
  end

  test 'errors are correct' do
    # Let's store one correct product and customer
    filename = create_xlsx([
      ['Tuote/Asiakas',                                           'Kpl', 'Myynti EUR' ],
      ['Yhteensä',                                                '',    123000       ],
      ["#{@customer.asiakasnro} #{@customer.nimi}",               '',    23000        ],
      ["#{@helmet.tuoteno} #{@helmet.osasto} #{@helmet.nimitys}", 10,    23000        ],
    ])

    params = {
      company_id: @company,
      user_id: @user,
      filename: filename,
      month: 1,
      year: 2016,
    }

    sales = Import::CustomerSales.new params

    assert_difference 'SalesOrder::Detail.count', 1 do
      result = sales.import
      assert_equal nil, result.rows.second.errors.first
    end

    # Try adding without month
    params = {
      company_id: @company,
      user_id: @user,
      filename: filename,
      year: 2016,
    }

    assert_raises(ArgumentError) { Import::CustomerSales.new params }

    # Try adding with incorrect product
    filename = create_xlsx([
      ['Tuote/Asiakas',                             'Kpl', 'Myynti EUR' ],
      ['Yhteensä',                                  '',    123000       ],
      ["#{@customer.asiakasnro} #{@customer.nimi}", '',    23000        ],
      ["666 #{@helmet.osasto} #{@helmet.nimitys}",  10,    23000        ],
    ])

    params = {
      company_id: @company,
      user_id: @user,
      filename: filename,
      month: 1,
      year: 2016,
    }

    # We get only one error
    sales = Import::CustomerSales.new params

    assert_difference 'SalesOrder::Detail.count', 1 do
      result = sales.import
      error = I18n.t('errors.import.product_not_found', product: '666')
      assert_equal error, result.rows.third.errors.first
    end

    # Try adding with incorrect customer
    filename = create_xlsx([
      ['Tuote/Asiakas',                                           'Kpl', 'Myynti EUR' ],
      ['Yhteensä',                                                '',    123000       ],
      ["999 #{@customer.nimi}",                                   '',    23000        ],
      ["#{@helmet.tuoteno} #{@helmet.osasto} #{@helmet.nimitys}", 10,    23000        ],
    ])

    params = {
      company_id: @company,
      user_id: @user,
      filename: filename,
      month: 1,
      year: 2016,
    }

    # We get only one error
    sales = Import::CustomerSales.new params

    assert_no_difference 'SalesOrder::Detail.count' do
      result = sales.import
      error = I18n.t('errors.import.customer_not_found', customer: '999')
      assert_equal error, result.rows.second.errors.first
    end
  end
end
