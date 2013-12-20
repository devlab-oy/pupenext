require 'test_helper'

class CurrenciesControllerTest < ActionController::TestCase

  def setup
    cookies[:pupesoft_session] = users(:joe).session
  end

  test 'should get all currencies' do
    request = {format: :html}

    get :index, request
    assert_response :success

    assert_template "index", "Template should be index"
  end

  test 'should show currency' do
    request = {format: :html, id: 1}

    get :show, request
    assert_response :success

    assert_template "edit", "Template should be edit"
  end

  test 'should show new currency form' do
    get :new
    assert_response :success

    assert_template 'new', 'Template should be new'
  end

  test 'should create new currency' do
    assert_difference('Currency.count') do
      post :create, currency: {nimi: 'TES', kurssi: 0.8}
    end

    assert_redirected_to currency_path(assigns(:currency))
    assert_equal 'Currency was successfully created.', flash[:notice]
  end

  test 'should not create new currency' do
    assert_no_difference('Currency.count') do
      post :create, currency: {}
      assert_template 'new', 'Template should be new'
    end
  end
end
