require 'test_helper'

class Administration::CarriersControllerTest < ActionController::TestCase
  def setup
    login users(:joe)
    @carrier = carrier(:hit)
  end

  test 'should get index' do
    get :index
    assert_response :success

    assert_template "index", "Template should be index"
  end
end
