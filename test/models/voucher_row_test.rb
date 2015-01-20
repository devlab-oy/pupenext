require 'test_helper'

class Head::VoucherRowTest < ActiveSupport::TestCase
  setup do
    @row = head_voucher_rows(:one)
  end

  test 'fixture should be valid' do
    assert @row.valid?, @row.errors.full_messages
    assert_equal "Acme Corporation", @row.voucher.company.nimi
  end

  test 'model relations' do
    assert_not_nil @row.voucher
    assert_not_nil @row.commodity
  end
end
