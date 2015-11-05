require 'test_helper'

class FinvoiceTest < ActiveSupport::TestCase
  fixtures %w(
    heads
    sales_order/orders
    terms_of_payments
    head/sales_invoice_rows
    head/sales_invoice_extras
    users
  )

  setup do
    Current.company = companies :acme
    @invoice = heads :si_one
  end

  test 'should initialize class with invoice' do
    assert Finvoice.new(invoice_id: @invoice.id)
    assert_raises(ActiveRecord::RecordNotFound) { Finvoice.new(invoice_id: nil) }
  end

  test 'should generate finvoice xml' do
    example = File.read Rails.root.join('test', 'assets', 'example_finvoice.xml')
    finvoice = Finvoice.new(invoice_id: @invoice.id).to_xml

    example = File.read Rails.root.join('test', 'assets', 'example_finvoice.xml')
    xml_example = Nokogiri::XML example
    xml_response = Nokogiri::XML finvoice

    # assert_equal xml_example.to_s, xml_response.to_s
    refute_empty finvoice
  end
end
