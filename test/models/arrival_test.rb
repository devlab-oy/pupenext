require 'test_helper'

class ArrivalTest < ActiveSupport::TestCase
  fixtures %w(
    arrivals
    purchase_order/orders
    purchase_order/rows
  )

  setup do
    @arrival = arrivals :arrival_one
    @invoice = arrivals :arrival_invoice
  end

  test 'fixtures are valid' do
    assert @arrival.valid?
    assert @invoice.valid?
  end

  test 'relations' do
    assert @arrival.rows.count > 0
  end
end
