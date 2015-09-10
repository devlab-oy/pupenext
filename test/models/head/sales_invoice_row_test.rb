require 'test_helper'

class Head::SalesInvoiceRowTest < ActiveSupport::TestCase
  fixtures %w(heads head/sales_invoice_rows)

  setup do
    @row = head_sales_invoice_rows(:one)
  end

  test 'fixture should be valid' do
    assert @row.valid?, @row.errors.full_messages
    assert_equal "Acme Corporation", @row.invoice.company.nimi
  end
end
