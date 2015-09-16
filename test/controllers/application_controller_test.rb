require 'test_helper'

# The purpose of ApplicationControllerTest is to test the common logic behind ApplicationController
class ApplicationControllerTest < ActionController::TestCase
  tests Administration::AccountsController
  fixtures %w(users companies accounts permissions sum_levels)

  setup do
    @user = users(:bob)
    login @user
  end

  test 'test current company' do
    get :index

    assigns(:accounts).each do |account|
      assert_equal @user.company.id, account.company.id
    end
  end

  test 'permissions ok without alias set' do
    account = accounts :account_100

    get :index
    assert_response :success

    get :edit, id: account.id
    assert_response :success

    patch :update, id: account.id, account: { nimi: 'new name' }
    assert_redirected_to accounts_path
  end

  test 'forbidden with alias set defined' do
    account = accounts :account_100

    get :index, alias_set: 'test_alias_set'
    assert_response :forbidden

    get :edit, id: account.id, alias_set: 'test_alias_set'
    assert_response :forbidden

    patch :update, id: account.id, account: { nimi: 'new name' }, alias_set: 'test_alias_set'
    assert_response :forbidden
  end

  test 'allowed with alias set defined' do
    account = accounts :account_100

    # Make sure our permissions have alias_set defined
    @user.permissions.read_access('/accounts').update_all(alanimi: 'test_alias_set')
    @user.permissions.update_access('/accounts').update_all(alanimi: 'test_alias_set')

    get :index, alias_set: 'test_alias_set'
    assert_response :success

    get :edit, id: account.id, alias_set: 'test_alias_set'
    assert_response :success

    patch :update, id: account.id, account: { nimi: 'new name' }, alias_set: 'test_alias_set'
    assert_redirected_to accounts_path
  end

  test 'forbidded without alias set' do
    account = accounts :account_100

    # Make sure our permissions have alias_set defined
    @user.permissions.read_access('/accounts').update_all(alanimi: 'test_alias_set')
    @user.permissions.update_access('/accounts').update_all(alanimi: 'test_alias_set')

    get :index
    assert_response :forbidden

    get :edit, id: account.id
    assert_response :forbidden

    patch :update, id: account.id, account: { nimi: 'new name' }
    assert_response :forbidden
  end
end
