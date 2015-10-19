require 'test_helper'
require 'minitest/mock'

class Reports::CustomerPriceListsControllerTest < ActionController::TestCase
  fixtures %w(customers)

  setup do
    login users(:joe)
    @customer = customers(:stubborn_customer)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "customer prices with product filters work with osasto and try" do
    LegacyMethods.stub(:customer_price, 22) do
      post :create, { commit: true, target_type: 1, target: @customer.id, osasto: 1000, try: 2000 }

      assert_equal Product.where(osasto: 1000, try: 2000), assigns(:products)

      assert_redirected_to customer_price_lists_path
    end
  end

  test "customer prices with product filters work with osasto" do
    LegacyMethods.stub(:customer_price, 22) do
      post :create, { commit: true, target_type: 1, target: @customer.id, osasto: 1000 }

      assert_equal Product.where(osasto: 1000), assigns(:products)

      assert_redirected_to customer_price_lists_path
    end
  end

  test "customer prices with product filters work with try" do
    LegacyMethods.stub(:customer_price, 22) do
      post :create, { commit: true, target_type: 1, target: @customer.id, try: 2000 }

      assert_equal Product.where(try: 2000), assigns(:products)

      assert_redirected_to customer_price_lists_path
    end
  end
end
