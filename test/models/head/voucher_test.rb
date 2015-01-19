require 'test_helper'

class Head::VoucherTest < ActiveSupport::TestCase
  setup do
    @voucher = head_vouchers(:one)
  end

  test 'fixture should be valid' do
    assert @voucher.valid?
  end
end
