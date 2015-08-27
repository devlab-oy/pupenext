require 'test_helper'

class Administration::CustomAttributesControllerTest < ActionController::TestCase
  fixtures %w(keywords)

  setup do
    login users(:bob)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should list custom attributes for set' do
    params = {
      table_name: 'asiakas',
      set_name: 'PROSPEKTI'
    }

    get :show_set, params
    assert_response :success
    assert assigns(:attribute_set)

    get :index, params
    assert_redirected_to custom_set_path(params)
    assert assigns(:attribute_set)
  end

  test 'should get index if params missing' do
    get :index, table_name: 'asiakas'
    assert_response :success
    assert_template :index

    get :index, set_name: 'PROSPEKTI'
    assert_response :success
    assert_template :index

    get :index, table_name: 'asiakas', set_name: 'PROSPEKTI'
    assert_response :redirect
  end
end
