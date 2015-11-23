require 'test_helper'

class Administration::OnlineStoresControllerTest < ActionController::TestCase
  fixtures %w(
    online_stores
  )

  setup do
    login users(:bob)

    @pupeshop = online_stores(:pupeshop)
    @magento  = online_stores(:magento)
  end

  test "index works" do
    get :index

    assert_response :success
    assert_not_nil assigns(:online_stores)
  end

  test "new works" do
    get :new

    assert_response :success
  end

  test "create works" do
    assert_difference('OnlineStore.count', 1) do
      post :create, online_store: { name: 'Test name 1' }
    end

    assert_redirected_to online_stores_url
  end

  test "show renders edit" do
    get :show, id: @pupeshop

    assert_response :success
    assert_template :edit
  end

  test "edit works" do
    get :edit, id: @pupeshop

    assert_response :success
  end

  test "update works" do
    patch :update, id: @pupeshop, online_store: { name: 'Updated name' }

    assert_redirected_to online_stores_url
  end

  test "destroy works" do
    assert_difference('OnlineStore.count', -1) do
      delete :destroy, id: @pupeshop
    end

    assert_redirected_to online_stores_path
  end
end
