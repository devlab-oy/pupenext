require 'test_helper'

class PackagesControllerTest < ActionController::TestCase

  def setup
    cookies[:pupesoft_session] = "IAOZQQAXYYDWMDBSWOEFSVBBI"
    @package = packages(:first)
    @keyword = keywords(:first)
    @package_code = package_codes(:first)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show, id: @package.id
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create" do
    request = {
      pakkaus: 'Kissa',
      pakkauskuvaus: '10'
    }

    assert_difference('Package.count', 1) do
      post :create, package: request
    end

    assert_redirected_to packages_path, response.body
  end

  test "should not create" do
    request = {
      pakkaus: 'Kissa',
      pakkauskuvaus: nil
    }

    assert_no_difference('Package.count') do
      post :create, package: request
    end

    assert_template "new", "Template should be new"
  end

  test "should get edit" do
    get :edit, id: @package.id
    assert_response :success
  end

  test "should update" do
    request = {
      pakkaus: 'Kissa',
      pakkauskuvaus: 'xxx'
    }

    patch :update, id: @package.id, package: request
    assert_redirected_to packages_path
  end

  test "should not update" do
    request = {
      pakkaus: 'Kissa',
      pakkauskuvaus: nil
    }

    patch :update, id: @package.id, package: request
    assert_template "edit", "Template should be edit"
  end

  test "should get edit_keyword" do
    get :edit_keyword, id: @package.id, keyword_id: @keyword.id
    assert_response :success
  end

  test "should get edit package_code" do
    get :edit_package_code, id: @package.id, package_code_id: @package_code.id
    assert_response :success
  end

  test "should update keyword" do
    request = {
      selitetark: 'Kissa'
    }

    post :update_keyword, id: @package.id, keyword_id:  @keyword.id, package_keyword: request
    assert_redirected_to package_path
  end

  test "should not update keyword" do
    request = {
      selitetark: nil
    }

    post :update_keyword, id: @package.id, keyword_id:  @keyword.id, package_keyword: request
    assert_template :edit_keyword, "Template should be edit_keyword"
  end

  test "should update package code" do
    request = {
      koodi: 'Kissa'
    }

    post :update_package_code, id: @package.id, package_code_id:  @package_code.id, package_code: request
    assert_redirected_to package_path
  end

  test "should not update package code" do
    request = {
      selitetark: nil
    }

    post :update_package_code, id: @package.id, package_code_id:  @package_code.id, package_code: request
    assert_template :edit_package_code, "Template should be edit_package_code"
  end

end
