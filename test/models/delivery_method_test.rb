require 'test_helper'

class DeliveryMethodTest < ActiveSupport::TestCase
  fixtures %w(
    customers
    delivery_methods
    sales_order/orders
  )

  setup do
    @kaukokiito = delivery_methods(:kaukokiito)
    @kiitolinja = delivery_methods(:kiitolinja)
    @nouto      = delivery_methods(:nouto)
  end

  test 'fixtures are valid' do
    assert @kaukokiito.valid?
    assert @kiitolinja.valid?
    assert @nouto.valid?
  end

  test 'relations' do
    assert @kaukokiito.customers.count > 0
    assert @nouto.sales_orders.count > 0
  end
end
