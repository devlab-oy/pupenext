require 'test_helper'

class StockTest < ActiveSupport::TestCase
  fixtures %w(
    products
  )

  setup do
    @stock   = Stock.new(products(:hammer))
    @product = products(:hammer)
  end

  test '#stock' do
    stock = @stock.stock
    assert stock > 0

    loc = @product.shelf_locations.first.dup
    loc.saldo = 100
    loc.hyllytaso = 'foo'
    loc.save!

    assert_equal stock + 100, Stock.new(@product).stock

    @product.update_attribute :ei_saldoa, :no_inventory_management
    assert_equal 0, Stock.new(@product).stock
  end
end
