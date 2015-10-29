require 'test_helper'
require 'minitest/mock'

class Reports::CustomerPriceListsControllerTest < ActionController::TestCase
  fixtures %w(customers products customer_prices)

  setup do
    login users(:joe)

    @customer = customers(:stubborn_customer)
    @hammer   = products(:hammer)
    @helmet   = products(:helmet)

    @params_customer = {
      commit:      true,
      target_type: 1,
      target:      @customer.id,
      osasto:      1000,
      try:         2000
    }

    @params_customer_subcategory = {
      commit:      true,
      target_type: 2,
      target:      @customer.ryhma,
      osasto:      1000,
      try:         2000
    }
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "customer prices with product filters work with osasto and try" do
    LegacyMethods.stub(:customer_price, 22) do
      post :create, @params_customer

      assert_equal Product.where(osasto: 1000, try: 2000), assigns(:products)
      assert_equal @customer, assigns(:customer)

      assert_response :success
    end
  end

  test "customer prices with product filters work with osasto" do
    @params_customer[:try] = nil

    LegacyMethods.stub(:customer_price, 22) do
      post :create, @params_customer

      assert_equal Product.where(osasto: 1000), assigns(:products)
      assert_equal @customer, assigns(:customer)

      assert_response :success
    end
  end

  test "customer prices with product filters work with try" do
    @params_customer[:osasto] = nil

    LegacyMethods.stub(:customer_price, 22) do
      post :create, @params_customer

      assert_equal Product.where(try: 2000), assigns(:products)
      assert_equal @customer, assigns(:customer)

      assert_response :success
    end
  end

  test "customer group prices with product filters work with osasto and try" do
    LegacyMethods.stub(:customer_subcategory_price, 30) do
      post :create, @params_customer_subcategory

      assert_equal Product.where(osasto: 1000, try: 2000), assigns(:products)
      assert_equal @customer.ryhma, assigns(:customer_subcategory)

      assert_response :success
    end
  end

  test "correct behaviour when customer cannot be found" do
    @params_customer[:target] = 921

    LegacyMethods.stub(:customer_price, 22) do
      post :create, @params_customer

      assert_response :not_found
      assert_template :index
    end
  end

  test "customer prices with contract prices work without product filters" do
    @params_customer[:contract_filter] = 2
    @params_customer[:osasto]          = nil
    @params_customer[:try]             = nil

    LegacyMethods.stub(:customer_price, 22) do
      post :create, @params_customer

      assert_response :success

      products = assigns(:products)

      assert_equal 2, products.count
      assert_includes products, @hammer
      assert_includes products, @helmet
    end
  end

  test "customer prices with contract prices work with product filters" do
    @params_customer[:contract_filter] = 2

    LegacyMethods.stub(:customer_price, 22) do
      post :create, @params_customer

      assert_response :success

      products = assigns(:products)

      assert_equal 1, products.count
      assert_includes products, @hammer
    end
  end
end
