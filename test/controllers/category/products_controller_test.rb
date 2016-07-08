require 'test_helper'

class Category::ProductsControllerTest < ActionController::TestCase
  fixtures %w(
    category/products
  )

  test '#index' do
    get :index, access_token: users(:bob).api_key

    assert_response :success

    json_response.each do |category|
      category.assert_valid_keys(:nimi, :koodi, :tunnus)
    end
  end
end
