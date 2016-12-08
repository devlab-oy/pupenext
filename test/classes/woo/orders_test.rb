require 'test_helper'

class Woo::OrdersTest < ActiveSupport::TestCase
  setup do
    @woocommerce = Woo::Orders.new(
      store_url: 'dummy_url',
      consumer_key: 'test_key',
      consumer_secret: 'test_secret',
      company_id: companies(:acme).id,
      orders_path: '/tmp',
      customer_id: 'customer_foo_123',
    )
  end

  test 'should initialize' do
    assert_instance_of Woo::Orders, @woocommerce
  end

  test 'generates edi_order from json response' do
    json_orders = File.read(Rails.root.join('test', 'assets', 'woocommerce', 'orders.json'))
    order = JSON.parse(json_orders).first
    edi_order = @woocommerce.build_edi_order(order)

    assert_match(/OSTOTIL.OT_ASIAKASNRO:customer_foo_123\n/, edi_order)
    assert_match(/OSTOTILRIV.OTR_TUOTEKOODI:A2\n/,           edi_order)
    assert_match(/OSTOTILRIV.OTR_TILATTUMAARA:2\n/,          edi_order)
  end
end
