require 'test_helper'

class SupplierProductInformationsControllerTest < ActionController::TestCase
  setup do
    login users(:bob)
  end

  test "index works" do
    get :index
    assert_response :success
  end
end
