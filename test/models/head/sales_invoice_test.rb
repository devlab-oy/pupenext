require 'test_helper'

class Head::SalesInvoiceTest < ActiveSupport::TestCase
  setup do
    @invoice = heads(:si_one)
  end

  test 'fixture should be valid' do
    assert @invoice.valid?
    assert_equal "Acme Corporation", @invoice.company.nimi
  end
end
