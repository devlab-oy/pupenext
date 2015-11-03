require 'test_helper'

class Head::SalesInvoiceTest < ActiveSupport::TestCase
  fixtures %w(
    head/sales_invoice_extras
    head/sales_invoice_rows
    head/voucher_rows
    heads
    locations
    products
    sales_order/orders
    users
  )

  setup do
    @invoice = heads(:si_one)

    @order = sales_order_orders(:so_one)
    @order.alatila = 'X'
    @order.laskunro = @invoice.laskunro
    @order.save
  end

  test 'fixture should be valid' do
    assert @invoice.valid?
    assert_equal "Acme Corporation", @invoice.company.nimi
  end

  test 'model relations' do
    assert_equal 1, @invoice.accounting_rows.count
    assert_equal 1, @invoice.rows.count

    @invoice.location = Location.first
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

  test 'credit invoice' do
    @invoice.arvo = 123
    refute @invoice.credit?

    @invoice.arvo = 0
    refute @invoice.credit?

    @invoice.arvo = -100
    assert @invoice.credit?
  end

  test 'seller' do
    @invoice.myyja = User.find_by(kuka: 'joe').id
    assert_equal "Joe Danger", @invoice.seller.nimi
  end

  test 'sales_order' do
    assert_equal @invoice.laskunro, @invoice.orders.invoiced.first.laskunro
  end

  test 'delivery period test' do
    row = head_sales_invoice_rows :one
    row.update_attributes! toimaika: "2015-01-10", toimitettuaika: "2015-01-11"
    row2 = row.dup.update_attributes! toimaika: "2015-01-12", toimitettuaika: "2015-01-13"

    @invoice.company.parameter.update_attributes! tilausrivien_toimitettuaika: :no_manual_deliverydates
    assert_equal Date.parse("2015-01-11"), @invoice.deliveryperiod_start
    assert_equal Date.parse("2015-01-13"), @invoice.deliveryperiod_end

    @invoice.company.parameter.update_attributes! tilausrivien_toimitettuaika: :manual_deliverydates_for_all_products
    @invoice.reload
    assert_equal Date.parse("2015-01-10"), @invoice.deliveryperiod_start
    assert_equal Date.parse("2015-01-12"), @invoice.deliveryperiod_end

    row.update_attributes! tuoteno: "x-consulting"

    @invoice.company.parameter.update_attributes! tilausrivien_toimitettuaika: :manual_deliverydates_when_product_inventory_not_managed
    @invoice.reload
    assert_equal Date.parse("2015-01-10"), @invoice.deliveryperiod_start
    assert_equal Date.parse("2015-01-13"), @invoice.deliveryperiod_end
  end

  test 'vat_specification' do
    vatspec = @invoice.vat_specification.first

    assert_equal 24,  vatspec[:vat_rate]
    assert_equal "S", vatspec[:vat_code]
    assert_equal 100, vatspec[:base_amount]
    assert_equal 24,  vatspec[:vat_amount]
  end

  test 'has_separate_recipient_address' do
    @invoice.extra.laskutus_nimi =  "Batman's bat cave"
    assert @invoice.has_separate_invoice_recipient

    @invoice.extra.laskutus_nimi =  @invoice.nimi
    @invoice.extra.laskutus_nimitark = @invoice.nimitark
    @invoice.extra.laskutus_osoite = @invoice.osoite
    @invoice.extra.laskutus_postitp =  @invoice.postitp
    @invoice.extra.laskutus_postino = @invoice.postino
    refute @invoice.has_separate_invoice_recipient

    @invoice.extra.laskutus_nimi =  ""
    refute @invoice.has_separate_invoice_recipient
  end

  test 'concat_person_name' do
    @invoice.tilausyhteyshenkilo = "Batman"
    assert_equal "Batman", @invoice.contact_person_name
  end

  test 'foreign_currency' do
    @invoice.valkoodi = "EUR"
    @invoice.company.valkoodi = "EUR"
    refute @invoice.foreign_currency

    @invoice.valkoodi = "SEK"
    assert @invoice.foreign_currency
  end

end
