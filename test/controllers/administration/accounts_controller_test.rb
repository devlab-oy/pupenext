require 'test_helper'

class Administration::AccountsControllerTest < ActionController::TestCase
  fixtures %w(accounts qualifiers sum_levels)

  setup do
    login users(:joe)
    @account = accounts(:account_100)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should search index" do
    params = {
      sisainen_taso: 33
    }
    get :index, params
    assert_response :success
    assert_equal 46, assigns(:accounts).count

    params = {
      tilino: 10
    }
    get :index, params
    assert_response :success
    assert_equal 6, assigns(:accounts).count

    params = {
      tilino: 10,
      nimi: '@Perustamismenot 210'
    }
    get :index, params
    assert_response :success
    assert_equal 1, assigns(:accounts).count
  end

  test 'should search and sort index' do
    params = {
      tilino: 10,
      sort: 'nimi',
      direction: 'desc'
    }
    get :index, params
    assert_response :success
    assert_equal 6, assigns(:accounts).count
    assert_equal 'Perustamismenot 410', assigns(:accounts).first.nimi

    params = {
      tilino: 10,
      sort: 'nimi',
      direction: 'asc'
    }
    get :index, params
    assert_response :success
    assert_equal 6, assigns(:accounts).count
    assert_equal 'Konsernimyyntisaamiset', assigns(:accounts).first.nimi
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
        ulkoinen_taso: 112
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

    assert_template :edit
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
