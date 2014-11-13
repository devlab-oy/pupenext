require 'test_helper'

class Administration::AccountsControllerTest < ActionController::TestCase
  def setup
    cookies[:pupesoft_session] = "IAOZQQAXYYDWMDBSWOEFSVBBI"
    @account = accounts(:first)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show, id: @account.id
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @account.id
    assert_response :success
  end

  test "should create" do
    request = {
      tilino: 1212,
      nimi: 'xxx',
      ulkoinen_taso: 1111
    }

    assert_difference('Account.count', 1) do
      post :create, account: request
    end

    assert_redirected_to accounts_path, response.body
  end

  test "should not create" do
    request = {
      tilino: 1212,
      nimi: nil,
      ulkoinen_taso: 1111
    }

    assert_no_difference('Account.count') do
      post :create, account: request
    end

    assert_template "new", "Template should be new"
  end

  test "should update" do
    request = {
      tilino: 1212,
      nimi: 'xxx',
      ulkoinen_taso: 1111
    }

    patch :update, id: @account.id, account: request
    assert_redirected_to accounts_path, response.body
  end
end
