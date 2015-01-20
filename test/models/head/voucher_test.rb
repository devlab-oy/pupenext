require 'test_helper'

class Head::VoucherTest < ActiveSupport::TestCase
  setup do
    @voucher = heads(:vo_one)
  end

  test 'fixture should be valid' do
    assert @voucher.valid?
    assert_equal "Acme Corporation", @voucher.company.nimi
  end

  test 'model relations' do
    assert_not_nil @voucher.commodity
    assert_not_nil @voucher.rows
  end
end
