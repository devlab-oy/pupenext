require 'test_helper'

class Administration::CompaniesControllerTest < ActionController::TestCase
  fixtures :all

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
        kuka: 'testi.testaaja@example.com',
        nimi: 'Testi Testaaja',
        salasana: Digest::MD5.hexdigest('kissa'),
        extranet: 'X',
      },
    ]

    assert_difference ['Company.unscoped.count', 'BankAccount.unscoped.count', 'Customer.unscoped.count'] do
      assert_difference 'User.unscoped.count', 5 do
        post :copy, access_token: users(:admin).api_key,
                    company: {
                      yhtio: 'testi',
                      nimi: 'Testi Oy',
                      osoite: 'Testikatu 3',
                      postino: '12345',
                      postitp: 'Testikaupunki',
                      ytunnus: '1234567-8',
                      bank_accounts_attributes: bank_accounts_attributes,
                      users_attributes: users_attributes,
                    },
                    create_as_customer_to_ids: [companies(:estonian).yhtio]

        assert_response :success
      end
    end

    assert_equal Company.unscoped.last,        Company.unscoped.find(json_response[:company][:id])
    assert_equal 'Testikatu 3',                Company.unscoped.last.osoite
    assert_equal '440',                        BankAccount.unscoped.last.oletus_selvittelytili
    assert_equal 'testi.testaaja@example.com', User.unscoped[-2].kuka
    assert_equal 'X',                          User.unscoped[-2].extranet

    # Extranet user for company where customer
    assert_equal 'testi.testaaja@example.com', User.unscoped[-1].kuka
    assert_equal 'X',                          User.unscoped[-1].extranet
  end

  test 'POST /companies/copy with invalid params' do
    assert_no_difference 'Company.unscoped.count' do
      post :copy, access_token: users(:admin).api_key, company: { yhtio: 'testi' }

      assert_response :unprocessable_entity
      assert_includes json_response.to_s, 'ei voi olla tyhjä'
    end
  end
end
