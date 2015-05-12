require 'test_helper'

class Administration::BankDetailsControllerTest < ActionController::TestCase
  setup do
    login users(:joe)
  end

  test "index returns all bank details" do
    get :index

    assert_response :success
    assert_equal 1, assigns(:bank_details).count
  end
end
