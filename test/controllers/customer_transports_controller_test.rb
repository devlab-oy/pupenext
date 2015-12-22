require 'test_helper'

class Administration::CustomerTransportsControllerTest < ActionController::TestCase
  fixtures %w(transports customers)

  setup do
    login users(:bob)

    @transport = transports(:one)

    @valid_params = {
      transportable_id: @transport.transportable_id,
      hostname: @transport.hostname,
      password: @transport.password,
      path: @transport.path,
      username: @transport.username,
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transport" do
    assert_difference('Transport.count') do
      post :create, customer_transport: @valid_params
    end

    assert_redirected_to customer_transports_path
  end

  test "should show transport" do
    get :show, id: @transport
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @transport
    assert_response :success
  end

  test "should update transport" do
    patch :update, id: @transport, customer_transport: @valid_params
    assert_redirected_to customer_transports_path
  end

  test "should destroy transport" do
    assert_difference('Transport.count', -1) do
      delete :destroy, id: @transport
    end

    assert_redirected_to customer_transports_path
  end
end
