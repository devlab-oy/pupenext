require 'test_helper'

class Administration::IncomingMailsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
