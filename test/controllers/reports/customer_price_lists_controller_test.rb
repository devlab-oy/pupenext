require 'test_helper'

class Reports::CustomerPriceListsControllerTest < ActionController::TestCase
  setup do
    login users(:joe)
  end
  test "should get index" do
    get :index
    assert_response :success
  end
end
