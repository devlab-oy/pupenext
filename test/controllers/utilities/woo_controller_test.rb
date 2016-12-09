require 'test_helper'
require 'minitest/mock'
require 'json_helper'

class Utilities::WooControllerTest < ActionController::TestCase
  include JsonHelper

  test 'complete order' do
    params = {
      access_token: users(:bob).api_key,
      store_url: 'dummy_url',
      consumer_key: 'test_key',
      consumer_secret: 'consumer_secret',
      order: {
        order_number: 123,
        tracking_code: 'ff123456',
      },
    }

    # failing complete order
    woo_orders = MiniTest::Mock.new
    woo_orders.expect :complete_order, nil, %w(123 ff123456)

    error_response = { error_messages: 'virhe tilauksen päivityksessä' }
    Woo::Orders.stub :new, woo_orders do
      get :complete_order, params
      assert_equal error_response, json
    end

    # succesfull complete order
    woo_orders.expect :complete_order, true, %w(123 ff123456)

    success_response = { message: 'tilaus päivitetty onnistuneesti' }
    Woo::Orders.stub :new, woo_orders do
      get :complete_order, params
      assert_equal success_response, json
    end
  end
end
