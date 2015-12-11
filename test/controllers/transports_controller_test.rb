require 'test_helper'

class Administration::TransportsControllerTest < ActionController::TestCase
  fixtures %w(transports customers)

  setup do
    login users(:bob)

    @transport = transports(:three)
    @customer_transport = transports(:one)

    @valid_params = {
      transportable_id: @transport.transportable_id,
      hostname: @transport.hostname,
      password: @transport.password,
      path: @transport.path,
      username: @transport.username,
    }

    @valid_customer_params = {
      transportable_id: @customer_transport.transportable_id,
      hostname: @customer_transport.hostname,
      password: @customer_transport.password,
      path: @customer_transport.path,
      username: @customer_transport.username,
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
      post :create, transport: @valid_params
    end

    assert_redirected_to transports_path
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
    patch :update, id: @transport, transport: @valid_params
    assert_redirected_to transports_path
  end

  test "should destroy transport" do
    assert_difference('Transport.count', -1) do
      delete :destroy, id: @transport
    end

    assert_redirected_to transports_path
  end

  test "should create customer transport" do
    assert_difference('Transport.count') do
      post :create_customer, transport: @valid_customer_params
    end

    assert_redirected_to transports_path
    assert_equal 'Customer', Transport.last.transportable_type
  end

  test "should update customer transport" do
    patch :update_customer, id: @customer_transport, transport: @valid_customer_params
    assert_redirected_to transports_path
  end
end
