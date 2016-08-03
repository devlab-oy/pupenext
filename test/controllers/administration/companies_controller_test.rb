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
          kuka: 'extranet@example.com',
          nimi: 'Extranet Testaaja',
          profiilit: 'Perustoiminnot',
          oletus_profiili: 'Perustoiminnot',
          salasana: Digest::MD5.hexdigest('kissa'),
          extranet: 'Z',
        },
      ],
    }

    # We copy all the users from current company
    # and create the extra user we passed in as user and extranet user
    user_count = User.count + 2

    assert_difference ['Company.unscoped.count', 'BankAccount.unscoped.count'] do
      assert_difference 'User.unscoped.count', user_count do
        post :copy, access_token: @admin.api_key, company: company_attributes, customer_companies: [estonia.yhtio]
        assert_response :success
      end
    end

    company = Current.company = Company.unscoped.find(json_response[:company][:id])

    assert_equal 'Testi Oy',              company.nimi
    assert_equal 'Testikatu 3',           company.osoite
    assert_equal 12,                      company.jarjestys
    assert_equal '440',                   company.bank_accounts.last.oletus_selvittelytili
    assert_equal 'extranet@example.com',  company.users.first.kuka
    assert_equal 'Z',                     company.users.first.extranet
    assert_equal 'Perustoiminnot',        company.users.first.profiilit
    assert_equal 'Perustoiminnot',        company.users.first.oletus_profiili

    Current.company = estonia
    assert_equal 'Testi Oy',              estonia.customers.last.nimi
    assert_equal '1234567-8',             estonia.customers.last.ytunnus
    assert_equal 'extranet@example.com',  estonia.users.last.kuka
    assert_equal 'X',                     estonia.users.last.extranet
    assert_equal 'Extranet',              estonia.users.last.profiilit
    assert_equal 'Extranet',              estonia.users.last.oletus_profiili
  end

  test 'POST /companies/copy with invalid params' do
    assert_no_difference 'Company.unscoped.count' do
      post :copy, access_token: @admin.api_key, company: { yhtio: 'acme' }

      assert_response :unprocessable_entity
      assert_includes json_response.to_s, 'on jo käytössä'
    end
  end
end
