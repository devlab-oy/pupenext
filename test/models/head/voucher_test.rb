require 'test_helper'

class Head::VoucherTest < ActiveSupport::TestCase

  def setup
    @voucher = accounting_vouchers(:voucher)
  end

  test 'fixture should be valid' do
    assert @voucher.valid?
  end

  test 'method should create voucher row with autosave' do
    params = {
      laatija: 'joe',
      muuttaja: 'joe',
      tapvm: Date.today,
      yhtio: 'acme',
      summa: 1000,
      selite: 'Diibadaaba',
      tilino: 112233,
      laadittu: Date.today
    }

    assert_difference('Accounting::Row.count') do
      @voucher.rows.build params
      @voucher.save
    end
  end

end
