require 'test_helper'

class Head::SalesInvoiceTest < ActiveSupport::TestCase
  setup do
    @invoice = head_sales_invoices(:one)
  end

  test 'fixture should be valid' do
    assert @invoice.valid?
  end
end
