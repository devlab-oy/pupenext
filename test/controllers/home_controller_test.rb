require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  setup do
    # Bob has access to /test, Max does not.
    login users(:bob)
  end

  test "forbidden if no session cookie" do
    logout

    get :index
    assert_response :unauthorized
  end

  test "success if session present and root_path requested" do
    get :index
    assert_response :success
  end

  test "success if we have access" do
    get :test
    assert_response :success
  end

  test "success if we have access even with parameters" do
    params = { foo: :bar, bar: :baz }
    get :test, params
    assert :success
  end

  test "access denied if no permissions" do
    login users(:max)

    get :test
    assert_response :forbidden
  end

end
