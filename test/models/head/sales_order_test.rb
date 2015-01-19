require 'test_helper'

class Head::SalesOrderTest < ActiveSupport::TestCase
  setup do
    @order = head_sales_orders(:one)
  end

  test 'fixture should be valid' do
    assert @order.valid?
    assert_equal "Acme Corporation", @order.company.nimi
  end
end
