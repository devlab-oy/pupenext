require 'test_helper'

class Head::PurchaseInvoiceTest < ActiveSupport::TestCase
  setup do
    @tilat = Head::PurchaseInvoice::INVOICE_TYPES
  end

  test 'fixtures should be valid' do
    @tilat.each do |t|
      i = heads("pi_#{t}")
      assert i.valid?
      assert_equal "Acme Corporation", i.company.nimi
    end
  end

  test 'model relations' do
    invoice = heads(:pi_H)
    assert_equal 1, invoice.accounting_rows.count
  end

  test 'invoice states' do
    # Create the alphabet
    range = "A".."Z"

    # Loop all allowed tila values
    @tilat.each do |tila|
      invoice = heads("pi_#{tila}")

      # Remove valid tila from range. Loop and refute others
      range.reject { |p| p == tila }.each do |char|
        invoice.tila = char
        refute invoice.valid?
      end

      # Try valid tila is valid
      invoice.tila = tila
      assert invoice.valid?
    end
  end
end
