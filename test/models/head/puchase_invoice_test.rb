require 'test_helper'

class Head::PurchaseInvoiceTest < ActiveSupport::TestCase
  setup do
    @invoice = head_purchase_orders(:one)
  end

  test 'fixtures should be valid' do
    assert @invoice.valid?
  end
end
