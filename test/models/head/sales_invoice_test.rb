require 'test_helper'

class Head::SalesInvoiceTest < ActiveSupport::TestCase
  fixtures %w(heads head/voucher_rows)

  setup do
    @invoice = heads(:si_one)
  end

  test 'fixture should be valid' do
    assert @invoice.valid?
    assert_equal "Acme Corporation", @invoice.company.nimi
  end

  test 'model relations' do
    assert_equal 1, @invoice.accounting_rows.count
  end
end
