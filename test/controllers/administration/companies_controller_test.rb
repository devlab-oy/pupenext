require 'test_helper'

class Administration::CompaniesControllerTest < ActionController::TestCase
  fixtures :all

  setup do
    login users(:bob)
  end

  test 'POST /companies/:id/copy' do
    assert_difference 'Company.unscoped.count' do
      post :copy, id: companies(:acme).id, company: { yhtio: 'testi', nimi: 'Testi Oy' }

      assert_response :success
    end

    assert_equal Company.unscoped.last, Company.unscoped.find(json_response['company']['id'])
  end
end
