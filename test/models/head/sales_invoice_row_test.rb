require 'test_helper'

class Head::SalesInvoiceRowTest < ActiveSupport::TestCase
  fixtures %w(heads head/sales_invoice_rows products)

  setup do
    @row = head_sales_invoice_rows(:one)
  end

  test 'fixture should be valid' do
    assert @row.valid?, @row.errors.full_messages
    assert_equal "Acme Corporation", @row.invoice.company.nimi
  end

  test 'relations' do
    assert_not_equal "", @row.product.nimitys
  end

  test 'delivery date' do
    @row.toimaika =  Date.parse("2015-01-01")
    @row.toimitettuaika = Date.parse("2015-01-02")
    @row.company.parameter.tilausrivien_toimitettuaika = :no_manual_deliverydates
    assert_equal Date.parse("2015-01-02"), @row.delivery_date

    @row.company.parameter.tilausrivien_toimitettuaika = :manual_deliverydates_when_product_inventory_not_managed
    @row.product.ei_saldoa = :inventory_management
    assert_equal Date.parse("2015-01-02"), @row.delivery_date

    @row.company.parameter.tilausrivien_toimitettuaika = :manual_deliverydates_when_product_inventory_not_managed
    @row.product.ei_saldoa = :no_inventory_management
    assert_equal Date.parse("2015-01-01"), @row.delivery_date

    @row.company.parameter.tilausrivien_toimitettuaika = :manual_deliverydates_for_all_products
    assert_equal Date.parse("2015-01-01"), @row.delivery_date
  end
end
