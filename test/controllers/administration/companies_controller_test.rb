require 'test_helper'

class Administration::CompaniesControllerTest < ActionController::TestCase
  fixtures :all

  setup do
    @admin = users :admin
  end

  test 'POST /companies/copy' do
    bank_accounts_attributes = [
      {
        nimi: 'Testitili',
        iban: 'FI9814283500171141',
        oletus_selvittelytili: 440,
        oletus_kulutili: 440,
        oletus_rahatili: 440,
        valkoodi: 'EUR',
        bic: 'NDEAFIHH',
      },
    ]

    users_attributes = [
      {
        kuka: 'extranet@example.com',
        nimi: 'Extranet Testaaja',
        salasana: Digest::MD5.hexdigest('kissa'),
        extranet: 'Z',
      },
    ]

    company_attributes = {
      yhtio: 'testi',
      nimi: 'Testi Oy',
      osoite: 'Testikatu 3',
      postino: '12345',
      postitp: 'Testikaupunki',
      ytunnus: '1234567-8',
      bank_accounts_attributes: bank_accounts_attributes,
      users_attributes: users_attributes,
    }

    assert_difference ['Company.unscoped.count', 'BankAccount.unscoped.count', 'Customer.unscoped.count'] do
      assert_difference 'User.unscoped.count', 5 do
        post :copy, access_token: @admin.api_key,
                    company: company_attributes,
                    customer_companies: [companies(:estonian).yhtio]
        assert_response :success
      end
    end

    company = Current.company = Company.unscoped.find(json_response[:company][:id])

    assert_equal 'Testi Oy',              company.nimi
    assert_equal 'Testikatu 3',           company.osoite
    assert_equal '440',                   company.bank_accounts.last.oletus_selvittelytili
    assert_equal 'extranet@example.com',  company.users.first.kuka
    assert_equal 'Z',                     company.users.first.extranet
  end

  test 'POST /companies/copy with invalid params' do
    assert_no_difference 'Company.unscoped.count' do
      post :copy, access_token: @admin.api_key, company: { yhtio: 'acme' }

      assert_response :unprocessable_entity
      assert_includes json_response.to_s, 'on jo käytössä'
    end
  end
end
