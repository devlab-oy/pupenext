require 'test_helper'

class UpdatePendingProductsTest < ActiveSupport::TestCase

  fixtures %w(
    products
    pending_updates
  )

  setup do
    @company = companies :acme
    @hammer = products :hammer
    @pending_update = pending_updates :update_1

    helmet = products :helmet

    @ids = [@hammer.id, helmet.id]
  end

  test 'initialize class' do
    assert UpdatePendingProducts.new company_id: @company.id, product_ids: [1,2,3]

    assert_raises { UpdatePendingProducts.new }
    assert_raises { UpdatePendingProducts.new company_id: nil, product_ids: nil }
    assert_raises { UpdatePendingProducts.new company_id: -1, product_ids: [] }
  end

  test 'update product with pending info' do
    pending2 = pending_updates(:update_1).dup
    pending2.key = 'nimitys'
    pending2.value = 'sledge'
    pending2.save!

    assert_difference 'PendingUpdate.count', -2 do
      pending = UpdatePendingProducts.new company_id: @company.id, product_ids: @ids
      pending.update
    end

    assert_equal 'sledge', @hammer.reload.nimitys
    assert_equal 100.5, @hammer.myyntihinta
  end

  test 'pending update result' do
    result = UpdatePendingProducts.new(company_id: @company.id, product_ids: @ids).update

    assert_equal 1,  result.update_count
    assert_equal 0,  result.failed_count
    assert_equal [], result.errors
  end

  test 'pending update errors' do
    @pending_update.update_columns key: 'nimitys', value: ''

    result = UpdatePendingProducts.new(company_id: @company.id, product_ids: @ids).update

    assert_equal 0,  result.update_count
    assert_equal 1,  result.failed_count
    assert_equal ["Nimitys ei voi olla tyhjä"], result.errors
  end
end
