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
    post :products
    assert_redirected_to data_import_path
  end
end
