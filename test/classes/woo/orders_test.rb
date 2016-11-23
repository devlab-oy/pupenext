require 'test_helper'

class Woo::OrdersTest < ActiveSupport::TestCase
  setup do
    @woocommerce = Woo::Orders.new
  end

  test 'should initialize' do
    assert_instance_of Woo::Orders.new, @woocommerce
  end

  test 'should get orders' do
    #orders = Woo::Orders.new.fetch
    #assert_equal "", orders
  end

  test 'generates edi_order from json response' do
    json_orders = File.read(Rails.root.join('test', 'assets', 'woocommerce', 'orders.json'))
    assert_match /OSTOTILRIV 1/, @woocommerce.build_edi_order(JSON.parse(json_orders).first)
  end
end
