require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  test "forbidden if no session cookie" do
    get :index
    assert :forbidden
  end

  test "success if session present" do
    cookies[:pupesoft_session] = "IAOZQQAXYYDWMDBSWOEFSVBBI"
    get :index
    assert :success
  end

end
