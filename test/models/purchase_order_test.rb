require 'test_helper'

class PurchaseOrderTest < ActiveSupport::TestCase

  def setup
    @po = purchase_orders(:purchase_order)
  end

  test 'fixtures should be valid' do
    assert @po.valid?
  end

end
