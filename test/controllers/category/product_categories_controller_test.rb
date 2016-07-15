require 'test_helper'

class Category::ProductCategoriesControllerTest < ActionController::TestCase
  fixtures %w(
    category/links
    category/products
    products
  )

  test '#index' do
    get :index, access_token: users(:bob).api_key

    assert_response :success

    assert_operator json_response.size, :>=, 4

    json_response.each do |category|
      category.assert_valid_keys(:nimi, :koodi, :tunnus)
    end
  end

  test '#index?ids=[1,2,3]' do
    ids = Category::Product.where(nimi: %w(Paidat V-aukkoiset)).pluck(:tunnus).join(',')

    get :index, ids: ids, access_token: users(:bob).api_key

    assert_response :success

    assert_equal 2, json_response.size

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

  test '#roots' do
    get :roots, access_token: users(:bob).api_key

    assert_response :success

    json_response.each do |category|
      category.assert_valid_keys(:nimi, :koodi, :tunnus)
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

    assert_equal category_products(:product_category_shirts).products.count, json_response.count

    json_response.each do |product|
      product.assert_valid_keys(:tunnus)
    end
  end

  test '#products?include_descendants=true' do
    get :products, id: category_products(:product_category_shirts).id,
                   include_descendants: true,
                   access_token: users(:bob).api_key

    assert_response :success

    total_shirts_count = category_products(:product_category_shirts_t_shirts_v_necks).products.count
    total_shirts_count += category_products(:product_category_shirts_t_shirts).products.count
    total_shirts_count += category_products(:product_category_shirts).products.count

    assert_equal total_shirts_count, json_response.count

    json_response.each do |product|
      product.assert_valid_keys(:tunnus)
    end
  end
end
