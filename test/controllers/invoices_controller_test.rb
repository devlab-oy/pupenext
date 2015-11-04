require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase
  setup do
    login users(:bob)
  end

  test "should get show" do
    get :show
    assert_response :success
  end
end
