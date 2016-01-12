require 'test_helper'

class SalesOrder::DetailTest < ActiveSupport::TestCase
  fixtures %w(
    customers
    sales_order/details
    sales_order/detail_rows
  )

  setup do
    @order = sales_order_details :do_one
    @customer = customers :stubborn_customer
  end

  test 'fixture should be valid' do
    assert @order.valid?
  end

  test 'model relations' do
    assert @order.rows.count > 0
    assert_equal "9", @order.rows.first.tyyppi
    assert_equal "Very stubborn customer", @order.customer.nimi
    assert_equal "Acme Corporation", @order.company.nimi
  end

  test 'default values' do
    Current.user = users :joe

    order = SalesOrder::Detail.create! liitostunnus: @customer.tunnus

    assert_equal @customer.nimi, order.nimi
    assert_equal @customer.ytunnus, order.ytunnus
    assert_equal @customer.osoite, order.osoite
  end
end
