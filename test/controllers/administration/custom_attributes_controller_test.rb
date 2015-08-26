require 'test_helper'

class Administration::CustomAttributesControllerTest < ActionController::TestCase
  fixtures %w(keywords)

  setup do
    login users(:bob)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end
end
