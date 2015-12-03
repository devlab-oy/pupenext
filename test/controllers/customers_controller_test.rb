require 'test_helper'

class CustomersControllerTest < ActionController::TestCase
  setup do
    login users(:joe)
  end

  test 'should find user by email' do
    get :find_by_email, email: "notfound@example.com"
    assert_response :success
    assert_equal "not found", json_response["error"]
    assert_equal 404,         json_response["status"]

    get :find_by_email, email: "email@ding.com"
    assert_response :success
    assert_equal "Very stubborn customer", json_response["nimi"]
  end
end
