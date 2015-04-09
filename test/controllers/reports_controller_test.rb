require 'test_helper'

class ReportsControllerTest < ActionController::TestCase

  setup do
    login users(:bob)
  end

  test 'should get balance sheet with depreciations report' do
    get :depreciations_balance_sheet
    assert_response :success
  end

  test 'should get depreciation difference report' do
    get :depreciation_difference
    assert_response :success
  end

  test 'should get balance statements report' do
    get :balance_statements
    assert_response :success
  end
end
