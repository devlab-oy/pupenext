require 'test_helper'

class Administration::UsersControllerTest < ActionController::TestCase
  fixtures %w(
    users
  )

  setup do
    @bob = users :bob
    @joe = users :joe

    login @bob
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @joe.tunnus
    assert_response :success
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'show should be edit' do
    get :show, id: @joe.tunnus
    assert_response :success
  end

  test 'should create user' do
    assert_difference('User.count') do
      params = {
        nimi: 'jukka majava',
        kuka: 'juma',
        eposti: 'juma@example.com',
        salasana: 'foobar',
      }

      post :create, user: params
      assert_redirected_to users_path
    end
  end

  test 'should not create user' do
    assert_no_difference('User.count') do
      params = { nimi: 'foo' }

      post :create, user: params
    end
  end

  test 'should update user' do
    params = { eposti: 'juma@example.com' }

    patch :update, id: @joe.id, user: params
    assert_redirected_to users_path
  end
end
