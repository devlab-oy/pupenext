require 'test_helper'

class FinvoiceTest < ActiveSupport::TestCase

  fixtures %w(heads)

  setup do
    Current.company = companies(:pullin_musiikki)
    @invoice = heads(:si_pulli)
  end

  test 'should initialize class with invoice' do
    assert Finvoice.new(invoice_id: @invoice.id)
    assert_raises(ActiveRecord::RecordNotFound) { Finvoice.new(invoice_id: nil) }
  end

  test 'should generate finvoice xml' do
    example = File.read Rails.root.join('test', 'assets', 'example_finvoice.xml')
    finvoice = Finvoice.new(invoice_id: @invoice.id)

    assert_equal example, finvoice.to_xml
  end
end
