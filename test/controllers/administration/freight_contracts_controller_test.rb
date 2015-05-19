require 'test_helper'

class Administration::FreightContractsControllerTest < ActionController::TestCase
  setup do
    login users(:joe)
  end

  test "index returns 350 freight contracts by default" do
    get :index

    assert_response :success
    assert_equal 350, assigns(:freight_contracts).size
  end

  test "index returns all freight contracts if set so in params" do
    get :index, limit: :off

    assert_response :success
    assert_equal 351, assigns(:freight_contracts).size
  end
end
