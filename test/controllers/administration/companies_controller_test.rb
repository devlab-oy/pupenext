require 'test_helper'

class Administration::CompaniesControllerTest < ActionController::TestCase
  fixtures :all

  setup do
    @admin = users :admin
  end

  test 'POST /companies/copy' do
    estonia = companies(:estonian)
    company_attributes = {
      yhtio: 'testi',
      nimi: 'Testi Oy',
      osoite: 'Testikatu 3',
      postino: '12345',
      postitp: 'Testikaupunki',
      ytunnus: '1234567-8',
      jarjestys: '12',
      bank_accounts_attributes: [
        {
          nimi: 'Testitili',
          iban: 'FI9814283500171141',
          oletus_selvittelytili: 440,
          oletus_kulutili: 440,
          oletus_rahatili: 440,
          valkoodi: 'EUR',
          bic: 'NDEAFIHH',
        },
      ],
      users_attributes: [
        {
          kuka: 'extranet@foobar.com',
          nimi: 'Extranet Testaaja',
          profiilit: 'Perustoiminnot',
          oletus_profiili: 'Perustoiminnot',
          salasana: Digest::MD5.hexdigest('kissa'),
          extranet: 'Z',
        },
      ],
    }

    params = {
      access_token: @admin.api_key,
      company: company_attributes,
      customer_companies: [estonia.yhtio],
      supplier_companies: [estonia.yhtio],
    }

    # We copy all the users from current company
    # and create the extra user we passed in as user and extranet user
    user_count = User.count + 2
    customer_count = Customer.count + 1

    assert_difference ['Company.unscoped.count', 'BankAccount.unscoped.count', 'Supplier.unscoped.count'] do
      assert_difference 'User.unscoped.count', user_count do
        assert_difference 'Customer.unscoped.count', customer_count do
          post :copy, params
          assert_response :success
        end
      end
    end

    company = Current.company = Company.unscoped.find(json_response[:company][:id])
    user = company.users.find_by kuka: 'extranet@foobar.com'

    assert_equal 'Testi Oy',            company.nimi
    assert_equal 'Testikatu 3',         company.osoite
    assert_equal 12,                    company.jarjestys
    assert_equal '440',                 company.bank_accounts.last.oletus_selvittelytili
    assert_equal 'extranet@foobar.com', user.kuka
    assert_equal 'Z',                   user.extranet
    assert_equal 'Perustoiminnot',      user.profiilit
    assert_equal 'Perustoiminnot',      user.oletus_profiili

    Current.company = estonia
    user = estonia.users.find_by kuka: 'extranet@foobar.com'

    assert_equal 'Testi Oy',            estonia.customers.last.nimi
    assert_equal '1234567-8',           estonia.customers.last.ytunnus
    assert_equal 'Testi Oy',            estonia.suppliers.last.nimi
    assert_equal '1234567-8',           estonia.suppliers.last.ytunnus
    assert_equal 'FI9814283500171141',  estonia.suppliers.last.ultilno
    assert_equal 'extranet@foobar.com', user.kuka
    assert_equal 'X',                   user.extranet
    assert_equal 'Extranet',            user.profiilit
    assert_equal 'Extranet',            user.oletus_profiili
  end

  test 'POST /companies/copy with invalid params' do
    assert_no_difference 'Company.unscoped.count' do
      post :copy, access_token: @admin.api_key, company: { yhtio: 'acme' }

      assert_response :unprocessable_entity

      error = json_response[:errors].first
      assert_equal 'Company',              error[:class_name],   json_response
      assert_equal 'Yhtio on jo käytössä', error[:errors].first, json_response
    end
  end
end
