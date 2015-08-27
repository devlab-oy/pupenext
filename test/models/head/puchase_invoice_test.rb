require 'test_helper'

class Head::PurchaseInvoiceTest < ActiveSupport::TestCase
  fixtures %w(heads head/voucher_rows)

  setup do
    @tilat = Head::PURCHASE_INVOICE_TYPES
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

  test 'list only invoices with voucher rows with given account number' do
    company = companies(:acme)
    assert_equal 2, company.purchase_invoices_paid.find_by_account('4444').count
    assert_equal 3, company.purchase_invoices_paid.find_by_account(['4444', '4443', 'notcorretaccount']).count
  end
end
