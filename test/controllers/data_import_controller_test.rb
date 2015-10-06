require 'test_helper'

class DataImportControllerTest < ActionController::TestCase
  setup do
    login users(:bob)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should update products" do
    file = fixture_file_upload 'files/product_upload_test.xlsx'

    post :product_keywords, file: file
    assert_not_nil flash[:notice]
    assert_redirected_to data_import_path
  end

  test "should get error on invalid file" do
    post :product_keywords
    assert_not_nil flash[:error]
    assert_redirected_to data_import_path

    post :product_keywords, file: ''
    assert_not_nil flash[:error]
    assert_redirected_to data_import_path
  end
end
