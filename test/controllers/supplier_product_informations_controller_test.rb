require 'test_helper'

class SupplierProductInformationsControllerTest < ActionController::TestCase
  setup do
    login users(:bob)
  end

  test "index works" do
    get :index
    assert_response :success
  end

  test 'searching with name works' do
    get :index, product_name: 'amb'

    assert_select 'td', { count: 1, text: 'Tramboline' }
    assert_select 'td', { count: 0, text: 'Chair' }
  end
end
