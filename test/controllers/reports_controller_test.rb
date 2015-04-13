require 'test_helper'

class ReportsControllerTest < ActionController::TestCase

  setup do
    login users(:bob)
  end

  test 'should get balance sheet with depreciations report' do
    example = DepreciationsBalanceSheetReport.new companies(:acme).id
    get :depreciations_balance_sheet
    assert_response :success
    assigns(:report)
    assert_equal example.class, assigns(:report).class
  end

  test 'should get depreciation difference report' do
    example = DepreciationDifferenceReport.new companies(:acme).id
    get :depreciation_difference
    assert_response :success
    assigns(:report)
    assert_equal example.class, assigns(:report).class
  end

  test 'should get balance statements report' do
    example = BalanceStatementsReport.new companies(:acme).id
    get :balance_statements
    assert_response :success
    assigns(:report)
    assert_equal example.class, assigns(:report).class
  end
end
