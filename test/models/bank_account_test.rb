require 'test_helper'

class BankAccountTest < ActiveSupport::TestCase

  def setup
    @ba = bank_accounts(:acme_account)
  end

  test "fixtures should be valid" do
    assert @ba.valid?, "#{@ba.errors.full_messages}"
  end

  test "duplicate accounts should fail" do
    two = @ba.dup
    refute two.valid?, "#{two.errors.full_messages}"
  end

  test "should validate iban" do
    @ba.iban = 'FI37-1590-3000-0007-76'
    assert @ba.valid?, 'Should be a valid iban'

    @ba.iban = 'Keijon Kassatili'
    assert @ba.valid?

    @ba.iban = 'NONO NOT A VALID IBAN3'
    refute @ba.valid?, "Should not be valid with letters and 1 number"
  end

  test "should generate iban from account number" do
    @ba.iban = '574044-25478'

    assert @ba.valid?
    assert_equal "FI0457404420005478", @ba.iban
  end

  test "should validate bic" do
    @ba.bic = 'DABAFIHH'
    assert @ba.valid?, "#{@ba.errors.full_messages}"

    @ba.bic = 'KEIJONBANK'
    refute @ba.valid?, "#{@ba.errors.full_messages}"
  end

end
