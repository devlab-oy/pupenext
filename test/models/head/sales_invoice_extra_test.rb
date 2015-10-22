require 'test_helper'

class Head::SalesInvoiceExtraTest < ActiveSupport::TestCase
  fixtures %w(
    heads
    head/sales_invoice_extras
  )

  setup do
    @invoiceextra = head_sales_invoice_extras(:si_one_extra)
  end

  test 'model relations' do
    assert_equal "Purjehdusseura Bitti ja Baatti ry", @invoiceextra.invoice.nimi
  end
end
