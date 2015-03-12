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
    assert_equal '100', @row.account.tilino
    assert_not_nil @row.voucher
    assert_not_nil head_voucher_rows(:two).purchase_invoice
    assert_not_nil head_voucher_rows(:three).purchase_order
    assert_not_nil head_voucher_rows(:four).sales_invoice
    assert_not_nil head_voucher_rows(:five).sales_order
    assert_not_nil head_voucher_rows(:six).commodity
  end

  test 'must happen in current active fiscal period' do
    params = {
      tilikausi_alku: '2015-01-01',
      tilikausi_loppu: '2015-06-30'
    }
    @row.voucher.company.update_attributes! params

    new_row = @row.dup
    new_row.tapvm = '2017-31-1'
    refute new_row.valid?
  end

  test 'allows only one account per commodity id' do
    # Commodity already has account number that differs from this row
    commodity = fixed_assets_commodities(:commodity_one)

    assert_not_equal commodity.fixed_assets_account, @row.tilino
    @row.commodity_id = commodity.id
    refute @row.valid?

    # Accepts the same account number
    @row.tilino = commodity.fixed_assets_account
    assert @row.valid?
  end

  test 'should split row' do
    @row.summa = 100
    @row.save!
    params = [
      { percent: 33.33, cost_centre: 1, target: 2, project: 3 },
      { percent: 33.33, project: 4},
      { percent: 33.34, target: 5},
    ]

    # Creates 3 rows and removes 1
    assert_difference('Head::VoucherRow.count', 2) do
      @row.split(params)
    end

    created_rows = companies(:acme).voucher_rows.last(3)

    assert_equal [33.33, 33.33, 33.34], created_rows.map(&:summa)
    assert_equal [1, 0, 0], created_rows.map(&:kustp)
    assert_equal [2, 0, 5], created_rows.map(&:kohde)
    assert_equal [3, 4, 0], created_rows.map(&:projekti)
  end

  test 'should not split row and raise error' do
    params = [
      { percent: 33.33, cost_centre: 1, target: 2, project: 3 },
      { percent: 33.33 },
      { percent: 33.34 },
      { target: 0 },
    ]

    # Rejects broken params
    assert_raise ArgumentError do
      @row.split(params)
    end

    params = [
      { percent: 33.33, cost_centre: 1, target: 2, project: 3 },
      { percent: 33.33 },
      { percent: 33.34 },
      { percent: 0 },
      { percent: 10 }
    ]

    # Rejects broken params
    assert_raise ArgumentError do
      @row.split(params)
    end
  end
end
