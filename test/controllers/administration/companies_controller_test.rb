require 'test_helper'

class Administration::CompaniesControllerTest < ActionController::TestCase
  fixtures :all

  test 'POST /companies/:id/copy' do
    assert_difference 'Company.unscoped.count' do
      post :copy, id: companies(:acme).id,
                  access_token: users(:admin).api_key,
                  company: {
                    yhtio: 'testi',
                    nimi: 'Testi Oy',
                    osoite: 'Testikatu 3',
                    postino: '12345',
                    postitp: 'Testikaupunki',
                    ytunnus: '1234567-8',
                  }

      assert_response :success
    end

    assert_equal Company.unscoped.last, Company.unscoped.find(json_response['company']['id'])
    assert_equal 'Testikatu 3',         Company.unscoped.last.osoite
  end

  test 'POST /companies/:id/copy with invalid params' do
    assert_no_difference 'Company.unscoped.count' do
      post :copy, id: companies(:acme).id, access_token: users(:admin).api_key, company: { yhtio: 'testi' }

      assert_includes json_response.to_s, 'ei voi olla tyhjä'
    end
  end

  test 'PATCH /companies/:id' do
    bank_accounts_attributes = [
      {
        nimi: 'Testitili',
        iban: 'FI9814283500171141',
        oletus_selvittelytili: Account.first.tilino,
        oletus_kulutili: Account.first.tilino,
        oletus_rahatili: Account.first.tilino,
        valkoodi: 'EUR',
        bic: 'NDEAFIHH',
      },
    ]

    company_params = {
      nimi: 'Testi Oy',
      bank_accounts_attributes: bank_accounts_attributes,
    }

    assert_difference 'BankAccount.count' do
      patch :update, id: companies(:acme).id, access_token: users(:admin).api_key, company: company_params
    end

    assert_response :success

    assert_equal 'Testi Oy',    companies(:acme).reload.nimi
    assert_equal Account.first, BankAccount.last.default_clearing_account
  end

  test 'PATCH /companies/:id with invalid params' do
    bank_accounts_attributes = [{ nimi: 'Testitili' }]
    company_params           = { nimi: 'Testi Oy', bank_accounts_attributes: bank_accounts_attributes }

    assert_no_difference 'BankAccount.count' do
      patch :update, id: companies(:acme).id, access_token: users(:admin).api_key, company: company_params
    end

    assert_response :unprocessable_entity
  end
end
