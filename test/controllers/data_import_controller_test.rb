require 'test_helper'

class DataImportControllerTest < ActionController::TestCase
  fixtures %w(
    keyword/product_information_types
    keyword/product_keyword_types
    keyword/product_parameter_types
    product/keywords
    products
  )

  setup do
    login users(:bob)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should update product keywords" do
    file = fixture_file_upload 'files/product_keyword_test.xlsx'
    Product::Keyword.delete_all

    assert_difference 'Product::Keyword.count', 3 do
      post :product_keywords, file: file
    end

    assert assigns(:spreadsheet)
    assert_response :success
  end

  test "should get error on a invalid file" do
    post :product_keywords
    assert_not_nil flash[:error]
    assert_redirected_to data_import_path

    post :product_keywords, file: ''
    assert_not_nil flash[:error]
    assert_redirected_to data_import_path
  end
end
