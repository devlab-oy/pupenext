require 'test_helper'

class Administration::PackagesControllerTest < ActionController::TestCase
  def setup
    login users(:bob)
    @package = packages(:steel_barrel)
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
      pakkauskuvaus: '10',
      leveys: 10,
      korkeus: 10,
      syvyys: 10,
      paino: 10
    }

    assert_difference('Package.count', 1) do
      post :create, package: request
    end

    assert_redirected_to packages_path, response.body
  end

  test "should not create" do
    request = {
      pakkaus: 'Kissa',
      kayttoprosentti: 0
    }

    assert_no_difference('Package.count') do
      post :create, package: request
    end
  end

  test "should get edit" do
    get :edit, id: @package.id
    assert_response :success
  end

  test "should update" do
    request = {
      pakkaus: 'Kissa',
      pakkauskuvaus: 'xxx',
      leveys: 10,
      korkeus: 10,
      syvyys: 10,
      paino: 10
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
    assert_template :edit, "Template should be edit"
  end

  test "should get edit_keyword" do
    skip
    get :edit_keyword, package_id: @package.id, keyword_id: @keyword.id
    assert_response :success
  end

  test "should get edit package_code" do
    skip
    get :edit_package_code, package_id: @package.id, package_code_id: @package_code.id
    assert_response :success
  end

  test "should update keyword" do
    skip
    request = {
      selitetark: 'Kissa'
    }

    post :update_keyword, package_id: @package.id, keyword_id:  @keyword.id, package_keyword: request
    assert_redirected_to package_path(@package)
  end

  test "should not update keyword" do
    skip
    request = {
      selitetark: nil
    }

    post :update_keyword, package_id: @package.id, keyword_id:  @keyword.id, package_keyword: request
    assert_template :edit_keyword, "Template should be edit_keyword"
  end

  test "should update package code" do
    skip
    request = {
      koodi: 'Kissa'
    }

    post :update_package_code, package_id: @package.id, package_code_id:  @package_code.id, package_code: request
    assert_redirected_to package_path(@package)
  end

  test "should not update package code" do
    skip
    request = {
      koodi: nil
    }

    post :update_package_code, package_id: @package.id, package_code_id:  @package_code.id, package_code: request
    assert_template :edit_package_code, "Template should be edit_package_code"
  end

  test "should get new keyword" do
    skip
    login users(:bob)

    get :new_keyword, package_id: @package.id
    assert_response :success
  end

  test "should get new package code" do
    skip
    get :new_package_code, package_id: @package.id
    assert_response :success
  end

  test "should create keyword" do
    skip
    request = {
      selitetark: 'Kissa'
    }

    assert_difference('Keyword.count', 1) do
      skip
      post :create_keyword,  package_id: @package.id, package_keyword: request
    end
  end

  test "should create package code" do
    skip
    request = {
      koodi: 'Kissa'
    }

    assert_difference('PackageCode.count', 1) do
      skip
      post :create_package_code, package_id: @package.id, package_code: request
    end
  end


  test "should not create keyword" do
    skip
    request = {
      selitetark: nil
    }

    assert_no_difference('Keyword.count') do
      skip
      post :create_keyword, package_id: @package.id, package_keyword: request
    end

    assert_template :new_keyword, "Template should be new keyword"
  end

  test "should not create package code" do
    skip
    request = {
      koodi: nil
    }

    assert_no_difference('PackageCode.count') do
      skip
      post :create_package_code, package_id: @package.id, package_code: request
    end

    assert_template :new_package_code, "Template should be new package code"
  end
end
