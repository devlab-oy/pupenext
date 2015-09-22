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
    @invoice.ytunnus = "123456"
    @invoice.maa = "FI"
    @invoice.company.maa = "FI"
    assert_equal "0012345-6", @invoice.ytunnus_human

    @invoice.maa = "EE"
    assert_equal "123456", @invoice.ytunnus_human

    @invoice.maa = "SE"
    @invoice.company.maa = "FI"
    assert_equal "SE-123456", @invoice.ytunnus_human

    @invoice.maa = "SE"
    @invoice.company.maa = "SE"
    assert_equal "123456", @invoice.ytunnus_human
  end

  test 'vatnumber human readable' do
    @invoice.ytunnus = "123"
    @invoice.maa = "FI"
    assert_equal "FI00000123", @invoice.vatnumber_human

    @invoice.maa = "EE"
    assert_equal "123", @invoice.vatnumber_human
  end

  test 'delivery period test' do
    row = head_sales_invoice_rows :one
    row.update_attributes! toimaika: "2015-01-10", toimitettuaika: "2015-01-11"
    row.dup.update_attributes! toimaika: "2015-01-12", toimitettuaika: "2015-01-13"

    @invoice.company.parameter.tilausrivien_toimitettuaika = :no_manual_deliverydates
    assert_equal Date.parse("2015-01-11"), @invoice.deliveryperiod_start
    assert_equal Date.parse("2015-01-13"), @invoice.deliveryperiod_end

    @invoice.company.parameter.tilausrivien_toimitettuaika = :manual_deliverydates_for_all_products
    assert_equal Date.parse("2015-01-10"), @invoice.deliveryperiod_start
    assert_equal Date.parse("2015-01-12"), @invoice.deliveryperiod_end

    @invoice.company.parameter.tilausrivien_toimitettuaika = :manual_deliverydates_when_product_inventory_not_managed
    assert_equal Date.parse("2015-01-10"), @invoice.deliveryperiod_start
    assert_equal Date.parse("2015-01-12"), @invoice.deliveryperiod_end
  end
end
