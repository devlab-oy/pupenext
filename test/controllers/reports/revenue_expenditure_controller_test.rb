require 'test_helper'

class Reports::RevenueExpenditureControllerTest < ActionController::TestCase
  setup do
    @user = users(:bob)
    login @user
  end

  test 'test get report' do
    get :revenue_expenditure
    assert_response :success
  end
end
