require 'test_helper'

class Administration::DeliveryMethodsControllerTest < ActionController::TestCase
  def setup
    login users(:joe)
    @delivery_method = delivery_methods(:kaukokiito)
  end

  test 'should get index' do
    get :index
    assert_response :success

    assert_template "index", "Template should be index"
  end
end
