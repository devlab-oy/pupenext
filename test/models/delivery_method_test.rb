require 'test_helper'

class DeliveryMethodTest < ActiveSupport::TestCase
  fixtures %w(
    customers
    delivery_methods
  )

  setup do
    @kaukokiito = delivery_methods(:kaukokiito)
    @kiitolinja = delivery_methods(:kiitolinja)
  end

  test 'fixtures are valid' do
    assert @kaukokiito.valid?
    assert @kiitolinja.valid?
  end

  test 'relations' do
    assert @kaukokiito.customers.count > 0
  end
end
