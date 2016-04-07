require 'test_helper'

class Administration::MailServersControllerTest < ActionController::TestCase
  setup do
    login users(:bob)
  end

  test 'GET index' do
    get :index

    assert_response :success
  end
end
