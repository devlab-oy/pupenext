require 'test_helper'

class Head::SalesInvoiceExtraTest < ActiveSupport::TestCase
  fixtures %w(
    contact_persons
    head/sales_invoice_extras
    heads
    sales_order/orders
  )

  setup do
    @invoiceextra = head_sales_invoice_extras(:si_one_extra)
  end

  test 'model relations' do
    assert_equal "Purjehdusseura Bitti ja Baatti ry", @invoiceextra.invoice.nimi
  end

  test 'contact_persons' do
    pirkko = contact_persons(:pirkko)

    @invoiceextra.yhteyshenkilo_tekninen =  pirkko.id

    assert_equal "Pirkko", @invoiceextra.technical_contact.nimi
  end
end
