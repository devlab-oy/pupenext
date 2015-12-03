require 'test_helper'

class CustomersControllerTest < ActionController::TestCase
  fixtures %w(customers)

  setup do
    @user = users(:bob)
    @customer = customers(:stubborn_customer)
    login @user
  end

  test 'api authorize' do
    get :find_by_email, email: "email@ding.com", access_token: "wrong"
    assert_response :unauthorized

    get :find_by_email, email: "email@ding.com", access_token: @user.api_key
    assert_response :success
  end

  test 'should create a new customer' do
    params = { customer: {
        ytunnus:    '111',
        asiakasnro: '111',
        nimi:       'Teppo Testaaja',
        nimitark:   '040 5555 555',
        osoite:     'Katukuja 12',
        postino:    '53500',
        postitp:    'Lappeenranta',
        maa:        'fi',
        email:      'teppo@example.com',
        puhelin:    '040 5555 555'
      },
      access_token: @user.api_key
    }

    assert_difference('Customer.count') do
      post :create, params
      assert_response :created
    end
  end

  test 'should update customer' do
    patch :update, id: @customer, customer: { nimi: "Antti Asiakas" }, access_token: @user.api_key
    assert_equal "Antti Asiakas", @customer.reload.nimi
  end

  test 'should find customer by email' do
    get :find_by_email, email: "notfound@example.com", access_token: @user.api_key
    assert_response :not_found
    assert_equal "Not found", json_response["error"]
    assert_equal 404,         json_response["status"]

    get :find_by_email, email: "email@ding.com", access_token: @user.api_key
    assert_response :success
    assert_equal "Very stubborn customer", json_response["nimi"]
  end
end
