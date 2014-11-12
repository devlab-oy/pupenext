require 'test_helper'

class SumLevelsControllerTest < ActionController::TestCase
  def setup
    cookies[:pupesoft_session] = users(:joe).session
    @user = users(:joe)
    @sum_level = sum_levels(:external)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should not get index" do
    @user.revoke_all('pupenext/sum_levels')
    get :index
    assert_response :forbidden
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should not get new" do
    @user.revoke_all('pupenext/sum_levels')
    get :new
    assert_response :forbidden
  end

  test "should show sum level" do
    request = {id: @sum_level.id}
    get :show, request
    assert_response :success
  end

  test "should create" do
    assert_response :success
  end

  test "should edit" do
    assert_response :success
  end

  test "should update" do
    assert_response :success
  end

  test "should destroy" do
    assert_response :success
  end
end
