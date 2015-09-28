require 'test_helper'

class PendingProductUpdatesControllerTest < ActionController::TestCase
  fixtures %w(products product/suppliers suppliers)

  setup do
    login users(:joe)
  end

  test 'should get index' do
    get :index
    assert_response :success

    assert_template "index", "Template should be index"

    hammer = products :hammer
    product_supplier = product_suppliers :domestic_product_supplier

    request = {
      toim_tuoteno: product_supplier[:toim_tuoteno],
      ei_saldoa: 'true',
      poistettu: 'true'
    }

    get :index, request
    assert_not_nil assigns(:products)
  end
end
