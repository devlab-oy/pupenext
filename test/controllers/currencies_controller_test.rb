require 'test_helper'

class CurrenciesControllerTest < ActionController::TestCase

  def setup
    cookies[:pupesoft_session] = users(:joe).session
  end

  test 'should get all currencies' do
    get :index
    assert_response :success

    assert_template "index", "Template should be index"
  end

  test 'should show currency' do
    request = {id: 1}

    get :show, request
    assert_response :success

    assert_template "edit", "Template should be edit"
  end

  test 'should show new currency form' do
    get :new
    assert_response :success

    assert_template 'new', 'Template should be new'
  end

  test 'should search for specific currency' do
    request = {nimi: 'EUR'}

    get :index, request
    assert_response :success

    assert_template "index", "Template should be index"
  end

  test 'should not have permission to create new currency' do
    assert_no_difference('Currency.count') do
      post :create, currency: {nimi: 'TES', kurssi: 0.8}
    end

    assert_redirected_to currencies_path
    assert_equal "You don't have permission to update.", flash[:notice]
  end

  test 'should create new currency' do
    cookies[:pupesoft_session] = users(:bob).session

    assert_difference('Currency.count') do
      post :create, currency: {nimi: 'TES', kurssi: 0.8}
    end

    assert_redirected_to currencies_path
    assert_equal 'Currency was successfully created.', flash[:notice]
  end

  test 'should not create new currency' do
    cookies[:pupesoft_session] = users(:bob).session

    assert_no_difference('Currency.count') do
      post :create, currency: {nimi: 'FOO_BAR'}
      assert_template 'new', 'Template should be new'
    end
  end

  test 'should update currency' do
    cookies[:pupesoft_session] = users(:bob).session

    patch :update, id: 1, currency: {nimi: 'TES'}

    assert_redirected_to currencies_path
    assert_equal 'Currency was successfully updated.', flash[:notice]
  end

  test 'should not update currency' do
    cookies[:pupesoft_session] = users(:bob).session

    patch :update, id: 1, currency: {nimi: ''}

    assert_template 'edit', 'Template should be edit'
  end
end
