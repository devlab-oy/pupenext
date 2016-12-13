require 'test_helper'

class StocksControllerTest < ActionController::TestCase
  fixtures %w(
    manufacture_order/composite_rows
    manufacture_order/recursive_composite_rows
    manufacture_order/rows
    products
    purchase_order/rows
    sales_order/rows
    shelf_locations
    stock_transfer/rows
    warehouses
  )

  setup do
    @product = products(:hammer)
    @api_key = users(:bob).api_key
  end

  test '#stock_available_per_warehouse' do
    params = {
      product_id: @product.id,
      warehouse_ids: [warehouses(:veikkola).id, warehouses(:kontula).id],
      access_token: @api_key,
    }

    get :stock_available_per_warehouse, params
    assert_response :success, json_response
    assert_equal({ '198948233': '10.0', '250043353': '2.0' }, json_response)
  end

  test '#stock_available_per_warehouse without warehouse_ids' do
    params = {
      product_id: @product.id,
      access_token: @api_key,
    }

    get :stock_available_per_warehouse, params
    assert_response :bad_request, json_response
  end

  test '#stock_available_per_warehouse with empty warehouse_ids' do
    params = {
      product_id: @product.id,
      warehouse_ids: [],
      access_token: @api_key,
    }

    get :stock_available_per_warehouse, params
    assert_response :bad_request, json_response
  end
end
