require 'test_helper'

class MonitoringControllerTest < ActionController::TestCase

  def setup
    login users(:joe)
  end

  test "should get nagios" do
    get :nagios_resque_email
    assert_response :success, response.body
  end

end
