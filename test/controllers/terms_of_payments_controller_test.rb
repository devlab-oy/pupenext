require 'test_helper'

class TermsOfPaymentsControllerTest < ActionController::TestCase

  def setup
    cookies[:pupesoft_session] = users(:joe).session
  end

  test 'should get all terms of payments' do
    request = {format: :html}

    get :index, request
    assert_response :success

    assert_template "index", "Template should be index"
  end
end
