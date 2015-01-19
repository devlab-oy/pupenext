require 'test_helper'

class PurchaseOrderTest < ActiveSupport::TestCase
  setup do
    @po = purchase_orders(:purchase_order)
  end

  test 'fixtures should be valid' do
    assert @po.valid?
  end

  test 'default scope' do
    assert_equal 0, PurchaseOrder.where("lasku.tila not in ('H','Y','M','P','Q')").count
  end
end
