require 'test_helper'

class Administration::ProductsControllerTest < ActionController::TestCase
  fixtures %w(products)

  setup do
    login users(:bob)
    @product = products(:hammer)
  end

  test "should create pending update" do

    PendingUpdate.delete_all

    request = {
      pending_updates_attributes: {
        "0" => {
          key: 'foo',
          value_type: 'Decimal',
          value: '123.0'
        }
      }
    }

    assert_difference('PendingUpdate.count', 1) do
      post :update, id: @product.id, product: request
    end
  end
end
