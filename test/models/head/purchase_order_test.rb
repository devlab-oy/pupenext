require 'test_helper'

class Head::PurchaseOrderTest < ActiveSupport::TestCase
  setup do
    @order = heads(:po_one)
  end

  test 'fixture should be valid' do
    assert @order.valid?
    assert_equal "Acme Corporation", @order.company.nimi
  end

  test 'model relations' do
    assert_equal 2, @order.accounting_rows.count
  end
end
