require 'test_helper'

class DataExportControllerTest < ActionController::TestCase
  setup do
    login users(:bob)
  end

  test 'product keywords ui' do
    get :product_keywords
    assert_response :success
  end

  test 'redirect to category selection if submit not pressed' do
    post :product_keywords_generate
    assert_redirected_to product_keyword_export_path
  end

  test 'product keyword export' do
    post :product_keywords_generate, commit: true, format: :xlsx
    assert_response :success
  end
end
