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

  test 'should get edit' do
    login users(:bob)
    get :edit, id: @carrier.tunnus
    assert_response :success
  end
end
