require 'test_helper'

class Reports::StockAvailabilityControllerTest < ActionController::TestCase
  fixtures %w(
    products
    purchase_order/orders
    purchase_order/rows
    head/sales_order/orders
    head/sales_order/rows
    shelf_locations
  )

  setup do
    login users(:bob)
  end

  test 'get report index and report selection' do
    get :index
    assert_response :success
    assert assigns(:period_options)
    assert assigns(:category_options)
    assert assigns(:subcategory_options)
    assert assigns(:brand_options)
  end

  test 'executing report to screen' do
    params = {
      period: 4,
      product_category: [],
      product_subcategory: [],
      product_brand: []
    }
    get :index, params
    assert assigns(:data)
    assert_not_nil assigns(:data)
    assert_template :_show_data
    assert_not_equal response.header['Content-Type'], 'application/pdf'
  end

  test 'executing report to pdf' do
    params = {
      period: 4,
      product_category: [],
      product_subcategory: [],
      product_brand: []
    }
    get :run, params
    assert_not_nil assigns(:data)
    assert_template :_show_data
    assert_template :to_pdf
    assert_equal response.header['Content-Type'], 'application/pdf'
  end

  test 'executing report fails without period parameter' do
    params = {
      product_category: [],
      product_subcategory: [],
      product_brand: []
    }

    get :index, params
    assert_nil assigns(:data)

    get :run, params
    assert_nil assigns(:data)
    assert_redirected_to stock_availability_path
  end

  test 'viewing connected sales orders' do
    order = head_sales_order_orders :so_one
    params = {
      order_numbers: [order.id]
    }
    get :view_connected_sales_orders, params
    assert_not_nil assigns(:orders)
    assert_template :view_connected_sales_orders
    assert_equal assigns(:orders).first.tunnus, order.id
  end

  test 'viewing does nothing without order numbers' do
    params = {
      order_numbers: []
    }
    get :view_connected_sales_orders, params
    assert_nil assigns(:orders)
    assert response.body.empty?

    get :view_connected_sales_orders
    assert_nil assigns(:orders)
    assert response.body.empty?
  end
end
