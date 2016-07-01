require 'test_helper'

class Reports::FullInstallmentsControllerTest < ActionController::TestCase
  setup do
    login users(:bob)
  end

  test 'get report index and report selection' do
    get :index
    assert_response :success
  end

  test 'executing report' do
    post :run
    assert_response :success
  end
end
