require 'test_helper'

class Head::PurchaseOrderTest < ActiveSupport::TestCase
  fixtures %w(heads head/voucher_rows)

  setup do
    @order = heads(:po_one)
  end

  test 'fixture should be valid' do
    assert @order.valid?
    assert_equal "Acme Corporation", @order.company.nimi
  end

  test 'model relations' do
    assert_equal 1, @order.accounting_rows.count
    assert_equal 1, @order.rows.count
  end
end
