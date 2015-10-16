require 'test_helper'

class DataExportControllerTest < ActionController::TestCase
  setup do
    login users(:bob)
  end

  test 'product keywords ui' do
    get :product_keywords
    assert_response :success
  end

  test 'product keyword export' do
    post :product_keywords_generate
    assert_response :success
  end
end
