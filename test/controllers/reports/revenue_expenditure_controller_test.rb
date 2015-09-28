require 'test_helper'

class Reports::RevenueExpenditureControllerTest < ActionController::TestCase
  setup do
    @user = users(:bob)
    login @user

    @first_header = I18n.t('reports.revenue_expenditure.index.history_revenue')
  end

  test 'test get report' do
    get :index
    assert_response :success

    assert_select "th", { text: @first_header, count: 0 }
  end

  test 'test executing report' do
    get :index, period: 1
    assert_response :success

    assert_select "th", { text: @first_header, count: 1 }
  end
end
