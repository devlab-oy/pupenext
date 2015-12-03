require 'test_helper'

class CustomersControllerTest < ActionController::TestCase
  fixtures %w(customers)

  setup do
    login users(:joe)
    @customer = customers(:stubborn_customer)
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
      }
    }

    assert_difference('Customer.count') do
      post :create, params
      assert_response :created
    end
  end

  test 'should update customer' do
    patch :update, id: @customer, customer: { nimi: "Antti Asiakas" }
    assert_equal "Antti Asiakas", @customer.reload.nimi
  end

  test 'should find customer by email' do
    get :find_by_email, email: "notfound@example.com"
    assert_response :success
    assert_equal "not found", json_response["error"]
    assert_equal 404,         json_response["status"]

    get :find_by_email, email: "email@ding.com"
    assert_response :success
    assert_equal "Very stubborn customer", json_response["nimi"]
  end
end
