require 'test_helper'

class FinvoiceTest < ActiveSupport::TestCase

  fixtures %w(
    heads
    terms_of_payments
    head/sales_invoice_rows
    head/sales_invoice_extras
    users
  )

  setup do
    Current.company = companies(:acme)
    @invoice = heads(:si_one)
  end

  test 'should initialize class with invoice' do
    assert Finvoice.new(invoice_id: @invoice.id)
    assert_raises(ActiveRecord::RecordNotFound) { Finvoice.new(invoice_id: nil) }
  end

  test 'should generate finvoice xml' do
    @invoice.myyja = User.find_by(kuka: 'joe').id
    @invoice.save

    example = File.read Rails.root.join('test', 'assets', 'example_finvoice.xml')
    finvoice = Finvoice.new(invoice_id: @invoice.id)

    #assert finvoice.to_xml != ""
    assert_equal example, finvoice.to_xml
  end
end
