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
    get :index
    assert_response :success
    refute assigns(:attribute_set)

    params = {
      set_name: 'PROSPEKTI'
    }

    get :index, custom_attributes: params
    assert_response :success
    assert assigns(:attribute_set)
  end
end
