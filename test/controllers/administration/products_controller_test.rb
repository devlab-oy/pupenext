require 'test_helper'

class Administration::ProductsControllerTest < ActionController::TestCase
  fixtures %w(products pending_updates)

  setup do
    login users(:bob)
    @product = products(:hammer)
  end

  test "should create pending update" do

    request = {
      pending_updates_attributes: {
        "0" => {
          key: 'nimitys',
          value: '123.0'
        }
      }
    }

    assert_difference 'PendingUpdate.count' do
      post :update, id: @product.id, product: request
    end
  end

  test "should not create pending update because invalid value" do

    request = {
      pending_updates_attributes: {
        "0" => {
          key: 'nimitys',
          value: ''
        }
      }
    }

    assert_no_difference 'PendingUpdate.count' do
      post :update, id: @product.id, product: request
    end
  end

  test "should not update product" do

    request = {
      nimitys: ''
    }

    assert_no_difference 'PendingUpdate.count' do
      post :update, id: @product.id, product: request
    end
  end

  test "should destroy pending update" do

    pending_update = pending_updates :update_1

    request = {
      pending_updates_attributes: {
        "0" => {
          id: pending_update.id,
          _destroy: 'true'
        }
      }
    }

    assert_difference 'PendingUpdate.count', -1 do
      post :update, id: @product.id, product: request
    end
  end

  test "should not destroy pending update" do

    request = {
      pending_updates_attributes: {
        "0" => {
          key: 'nimitys',
          value: '123.0',
          _destroy: 'true'
        }
      }
    }

    assert_no_difference 'PendingUpdate.count' do
      post :update, id: @product.id, product: request
    end
  end

  test "should update pending update" do

    pending_update = pending_updates :update_1

    request = {
      pending_updates_attributes: {
        "0" => {
          id: pending_update.id,
          value: 200
        }
      }
    }

    post :update, id: @product.id, product: request

    p = PendingUpdate.where(id: pending_update.id)
    assert_equal "200", p[0].value
  end

  test "should not update pending update" do

    pending_update = pending_updates :update_1

    request = {
      pending_updates_attributes: {
        "0" => {
          id: pending_update.id,
          key: 'nimitys',
          value: ''
        }
      }
    }

    post :update, id: @product.id, product: request

    p = PendingUpdate.where(id: pending_update.id)
    assert_not_equal "nimitys", p[0].key
  end
end
