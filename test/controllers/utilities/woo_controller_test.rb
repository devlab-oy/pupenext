require 'test_helper'
require 'minitest/mock'
require 'json_helper'

class Utilities::WooControllerTest < ActionController::TestCase
  include JsonHelper

  setup do
    @valid_params = {
      access_token: users(:bob).api_key,
      store_url: 'dummy_url',
      consumer_key: 'test_key',
      consumer_secret: 'consumer_secret',
      order: {
        order_number: 123,
        tracking_code: 'ff123456',
      },
    }
  end

  test 'failing complete order' do
    woo_orders = MiniTest::Mock.new
    woo_orders.expect :complete_order, nil, %w(123 ff123456)

    error_response = { message: 'virhe tilauksen päivityksessä' }
    Woo::Orders.stub :new, woo_orders do
      get :complete_order, @valid_params
      assert_equal error_response, json
    end
  end

  test 'succesfull complete order' do
    woo_orders = MiniTest::Mock.new
    woo_orders.expect :complete_order, true, %w(123 ff123456)

    success_response = { message: 'tilaus päivitetty onnistuneesti' }
    Woo::Orders.stub :new, woo_orders do
      get :complete_order, @valid_params
      assert_equal success_response, json
    end
  end

  test 'invalid params' do
    params = {
      access_token: users(:bob).api_key,
      store_url: 'foo',
    }
    error = { message: 'param is missing or the value is empty: consumer_key' }

    get :complete_order, params
    assert_response :bad_request, json
    assert_equal error, json
  end
end
