require 'test_helper'

class Head::SalesOrderTest < ActiveSupport::TestCase
  fixtures %w(heads)

  setup do
    @order = heads(:so_one)
  end

  test 'fixture should be valid' do
    assert @order.valid?
    assert_equal "Acme Corporation", @order.company.nimi
  end

  test 'model relations' do
    assert_equal 1, @order.accounting_rows.count
  end
end
