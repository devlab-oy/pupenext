require 'test_helper'

class Administration::RevenueExpenditureReportDatumControllerTest < ActionController::TestCase
  fixtures %w(keywords)

  setup do
    login users(:bob)
    @data = keywords(:weekly_alternative_expenditure_one)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @data.tunnus
    assert_response :success

    get :show, id: @data.tunnus
    assert_response :success
  end
end
