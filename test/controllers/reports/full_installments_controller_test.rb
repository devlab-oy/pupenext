require 'test_helper'

class Reports::FullInstallmentsControllerTest < ActionController::TestCase
  setup do
    login users(:bob)
  end

  test 'get report index and report selection' do
    get :index
    assert_response :success
  end

  test 'executing report to screen' do
    params = {
      format: :html
    }

    post :run, params
  end

  test 'executing report to excel' do
    params = {
      format: :xlsx
    }

    post :run, params
  end
end
