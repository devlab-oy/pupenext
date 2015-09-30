require 'test_helper'

class PendingProductUpdatesControllerTest < ActionController::TestCase
  fixtures %w(products product/suppliers suppliers)

  setup do
    login users(:joe)
  end

  test 'should get index' do
    get :index
    assert_response :success

    assert_template :index, "Template should be index"
  end

  test 'should get list' do
    get :list
    assert_response :success

    assert_template :index, "Without pressing submit-button template should be index"

    product_supplier = product_suppliers :domestic_product_supplier

    request = {
      'tuotteen_toimittajat.toim_tuoteno' => product_supplier[:toim_tuoteno],
      ei_saldoa: 'true',
      poistettu: 'true',
      commit: 'search'
    }

    get :list, request
    assert_template :list, "By pressing submit-button template should be list"
    assert_not_nil assigns(:products)
  end

end
