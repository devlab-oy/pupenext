require 'test_helper'

class SupplierProductInformationsControllerTest < ActionController::TestCase
  fixtures %i(
    supplier_product_informations
  )

  setup do
    login users(:bob)
  end

  test "index works" do
    get :index
    assert_response :success
  end

  test 'searching with product name works' do
    get :index, product_name: 'amb'

    assert_select 'td', { count: 1, text: 'Tramboline' }
    assert_select 'td', { count: 0, text: 'Chair' }
  end

  test 'searching with product id works' do
    get :index, product_id: '2'

    assert_select 'td', { count: 1, text: 'Chair' }
    assert_select 'td', { count: 0, text: 'Tramboline' }
  end
end
