require 'test_helper'

class Woo::BaseTest < ActiveSupport::TestCase
  setup do
    @woocommerce = Woo::Orders.new
  end

  test 'should initialize' do
    assert_instance_of Woo::Base, @woo
  end

  test 'should get orders' do
    orders = Woo::Orders.new.fetch
    assert_equal "", orders
  end

  test 'generates edi_order from json response' do
     orders = File.read(Rails.root.join('test', 'assets', 'woocommerce', 'orders.json'))
     # @woocommerce.build_edi_order(orders)
     JSON.parse(orders).first
  end
end
