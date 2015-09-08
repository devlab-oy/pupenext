require 'test_helper'

class Head::VoucherTest < ActiveSupport::TestCase
  fixtures %w(heads head/voucher_rows fixed_assets/commodities)

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
    assert_equal 3, @voucher.accounting_rows.count
  end

  test 'find by account works' do
    company = companies(:acme)
    assert_equal 2, company.vouchers.find_by_account('4444').count
    assert_equal 3, company.vouchers.find_by_account(['4443', '4444']).count
  end
end
