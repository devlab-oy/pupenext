require 'test_helper'

class SumLevelsControllerTest < ActionController::TestCase

  def setup
    cookies[:pupesoft_session] = users(:joe).session
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
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
