require 'test_helper'

class Reports::CommodityFinancialStatementsControllerTest < ActionController::TestCase
  fixtures %w(
    fiscal_years
  )

  setup do
    login users(:bob)
  end

  test 'get index' do
    get :index
    assert_response :success
  end

  test 'create report' do
    params = {
      start_date: Date.today.beginning_of_year,
      end_date:   Date.today.end_of_year,
    }

    post :create, params
    assert_response :success
  end
end
