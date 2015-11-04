require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase
  setup do
    login users(:bob)
  end

  test "should get xml" do
    get :show, format: :xml
    assert_response :success
  end
end
