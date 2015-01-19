require 'test_helper'

class Head::PurchaseOrderTest < ActiveSupport::TestCase
  setup do
    @order = head_purchase_orders(:one)
  end

  test 'fixture should be valid' do
    assert @order.valid?
    assert_equal "Acme Corporation", @order.company.nimi
  end
end
