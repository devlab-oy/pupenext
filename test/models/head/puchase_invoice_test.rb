require 'test_helper'

class Head::PurchaseInvoiceTest < ActiveSupport::TestCase
  setup do
    @invoice = heads(:pi_one)
  end

  test 'fixtures should be valid' do
    assert @invoice.valid?
    assert_equal "Acme Corporation", @invoice.company.nimi
  end

  test 'model relations' do
    assert_equal 1, @invoice.accounting_rows.count
  end
end
