require 'test_helper'

class InstallmentTest < ActiveSupport::TestCase
  fixtures %w(
    installments
    sales_order/orders
  )

  setup do
    @fourty = installments :fourty
    @sixty  = installments :sixty
  end

  test 'all fixtures should be valid' do
    assert @fourty.valid?, @fourty.errors.full_messages
    assert @sixty.valid?,  @sixty.errors.full_messages
  end

  test 'relations' do
    assert_equal "Lenni", @fourty.parent_order.nimi
    assert_equal "Kalle", @fourty.sales_order.nimi

    assert_equal "Lenni", @sixty.parent_order.nimi
    assert_equal "Lenni", @sixty.sales_order.nimi
  end
end
