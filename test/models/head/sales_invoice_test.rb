require 'test_helper'

class Head::SalesInvoiceTest < ActiveSupport::TestCase
  fixtures %w(heads head/voucher_rows head/sales_invoice_rows locations)

  setup do
    @invoice = heads(:si_one)
  end

  test 'fixture should be valid' do
    assert @invoice.valid?
    assert_equal "Acme Corporation", @invoice.company.nimi
  end

  test 'model relations' do
    assert_equal 1, @invoice.accounting_rows.count
    assert_equal 1, @invoice.rows.count
    assert_equal Location, @invoice.location.class
  end

  test 'ytunnus human readable' do
    @invoice.ytunnus = "123"
    @invoice.maa = "FI"
    assert_equal "FI00000123", @invoice.ytunnus_human
  end

  test 'delivery period start' do
    row = head_sales_invoice_rows :one
    row.update_attributes! toimaika: "2015-01-10", toimitettuaika: "2015-01-11"
    row.dup.update_attributes! toimaika: "2015-01-12", toimitettuaika: "2015-01-13"
    @invoice.company.parameter.tilausrivien_toimitettuaika = :no_manual_deliverydates

    assert_equal Date.parse("2015-01-11"), @invoice.deliveryperiod_start

    @invoice.company.parameter.tilausrivien_toimitettuaika = :all_products_manual_deliverydates

    assert_equal Date.parse("2015-01-10"), @invoice.deliveryperiod_start
  end

  test 'delivery period end' do
    assert_equal Date.today, @invoice.deliveryperiod_end
  end

end
