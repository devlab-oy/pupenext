require 'test_helper'

class Administration::AccountsControllerTest < ActionController::TestCase
  def setup
    login users(:joe)
    @account = accounts(:first)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    login users(:bob)
    get :new
    assert_response :success
  end

  test "should show account" do
    request = { id: @account.id }
    get :show, request
    assert_response :success
  end

  test "should create" do
    login users(:bob)

    assert_difference('Account.count', 1) do
      request = {
        tilino: 1212,
        nimi: 'xxx',
        ulkoinen_taso: 1111
      }
      post :create, account: request
    end

    assert_redirected_to accounts_path
  end

  test "does not create record with invalid parameters" do
    login users(:bob)

    assert_no_difference('Account.count') do
      request = { tilino: '', nimi: 'xxx', ulkoinen_taso: 1111 }
      post :create, account: request
    end

    assert_template :new
  end

  test "should get edit" do
    login users(:bob)

    get :edit, id: @account.id
    assert_response :success
  end

  test "should update" do
    login users(:bob)

    patch :update, id: @account.id, account: { nimi: 'Uusi nimi' }
    assert_equal "Tili päivitettiin onnistuneesti", flash[:notice]
    assert_redirected_to accounts_path
  end

  test "should not update with invalid data" do
    login users(:bob)

    patch :update, id: @account.id, account: { nimi: '' }
    assert_template :edit
  end

  test "should destroy" do
    login users(:bob)

    assert_difference('Account.count', -1) do
      delete :destroy, id: @account.id
    end

    assert_equal "Tili poistettiin onnistuneesti", flash[:notice]
    assert_redirected_to accounts_path
  end

  test "doesn't destroy with insufficient permissions" do
    assert_no_difference("Account.count") { delete :destroy, id: @account.id }
  end

  test "doesn't update with insufficient permissions" do
    patch :update, id: @account.id, account: { nimi: 'Uusi nimi' }
    assert_response :forbidden
  end
end
