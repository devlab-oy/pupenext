require 'test_helper'

class Accounting::VoucherTest < ActiveSupport::TestCase

  def setup
    # Valid accounting voucher
    @voucher = accounting_vouchers(:one)
  end

  test 'fixture should be valid' do
    assert @voucher.valid?
  end

end
