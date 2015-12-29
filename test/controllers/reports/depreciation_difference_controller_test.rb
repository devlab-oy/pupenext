require 'test_helper'

class Reports::DepreciationDifferenceControllerTest < ActionController::TestCase
  setup do
    login users(:bob)
  end

  test 'get index' do
    get :index
    assert_response :success
  end

  test 'create report' do
    post :create
    assert_response :success
  end
end
