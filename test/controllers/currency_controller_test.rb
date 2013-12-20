require 'test_helper'

class CurrencyControllerTest < ActionController::TestCase

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
    request = {format: :html}

    get :new, request
    assert_response :success

    assert_template 'new', 'Template should be new'
  end
end
