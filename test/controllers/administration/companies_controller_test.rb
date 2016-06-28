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
end
