require 'test_helper'

class DataExportControllerTest < ActionController::TestCase
  setup do
    login users(:bob)
  end

  test 'index' do
    get :index
    assert_response :success
  end

  test 'product keyword export' do
    post :product_keywords
    assert_response :success
  end
end
