require 'test_helper'

class Administration::AccountsControllerTest < ActionController::TestCase
  def setup
    cookies[:pupesoft_session] = users(:joe).session
    @account = accounts(:first)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    cookies[:pupesoft_session] = users(:bob).session
    get :new
    assert_response :success
  end

  test "should show account" do
    request = { id: @account.id }
    get :show, request
    assert_response :success
  end

  test "should create" do
    cookies[:pupesoft_session] = users(:bob).session
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
    cookies[:pupesoft_session] = users(:bob).session

    assert_no_difference('Account.count') do
      request = { tilino: '', nimi: 'xxx', ulkoinen_taso: 1111 }
      post :create, account: request
    end

    assert_template :new
  end

  test "should get edit" do
    cookies[:pupesoft_session] = users(:bob).session
    get :edit, id: @account.id
    assert_response :success
  end

  test "should update" do
    cookies[:pupesoft_session] = users(:bob).session
    patch :update, id: @account.id, account: { nimi: 'Uusi nimi' }
    assert_equal "Tili päivitettiin onnistuneesti", flash[:notice]
    assert_redirected_to accounts_path
  end

  test "should not update with invalid data" do
    cookies[:pupesoft_session] = users(:bob).session
    patch :update, id: @account.id, account: { nimi: '' }
    assert_template :edit
  end

  test "should destroy" do
    cookies[:pupesoft_session] = users(:bob).session
    assert_difference('Account.count', -1) do
      delete :destroy, id: @account.id
    end

    assert_equal "Tili poistettiin onnistuneesti", flash[:notice]
    assert_redirected_to accounts_path
  end

  test "doesn't update with insufficient permissions" do
    cookies[:pupesoft_session] = users(:joe).session

    patch :update, id: @account.id, account: { nimi: 'Uusi nimi' }

    assert_equal "Sinulla ei ole päivitysoikeuksia", flash[:notice]
    assert_redirected_to accounts_path
  end
end
