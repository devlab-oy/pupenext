require 'test_helper'

class Reports::StockListingCsvControllerTest < ActionController::TestCase
  setup do
    login users(:bob)
  end

  test 'test get report' do
    get :index
    assert_response :success
  end

  test 'test executing report' do
    post :run
    assert_redirected_to stock_listing_csv_path
    assert_not_equal "", flash.notice
  end
end
