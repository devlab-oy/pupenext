require 'test_helper'

class Category::ProductsControllerTest < ActionController::TestCase
  fixtures %w(
    category/links
    category/products
    products
  )

  test '#index' do
    get :index, access_token: users(:bob).api_key

    assert_response :success

    json_response.each do |category|
      category.assert_valid_keys(:nimi, :koodi, :tunnus)
    end
  end

  test '#show' do
    get :show, id: category_products(:product_category_pants).id, access_token: users(:bob).api_key

    assert_response :success

    json_response.assert_valid_keys(:nimi, :koodi, :tunnus)
  end

  test '#tree' do
    get :tree, access_token: users(:bob).api_key

    assert_response :success

    json_response.each do |category|
      category.assert_valid_keys(:nimi, :koodi, :tunnus, :children)
    end
  end

  test '#children' do
    get :children, id: category_products(:product_category_shirts).id, access_token: users(:bob).api_key

    assert_response :success

    json_response.each do |category|
      category.assert_valid_keys(:nimi, :koodi, :tunnus)
    end
  end

  test '#products' do
    get :products, id: category_products(:product_category_shirts).id, access_token: users(:bob).api_key

    assert_response :success

    json_response.each do |product|
      product.assert_valid_keys(:tunnus)
    end
  end
end
