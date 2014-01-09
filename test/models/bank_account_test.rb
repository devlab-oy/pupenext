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
    assert @ba.valid?, @ba.errors.full_messages

    @ba.iban = 'NONO NOT A VALID IBAN3'
    refute @ba.valid?
  end

  test "should validate account number" do
    @ba.tilino = '574044-25478'
    assert @ba.valid?, "574044-25478 #{@ba.errors.full_messages}"

    @ba.tilino = '5740 4420 0054 78'
    assert @ba.valid?, "57404420005478 #{@ba.errors.full_messages}"

    @ba.tilino = '57404420005478000'
    refute @ba.valid?, "57404420005478000 #{@ba.errors.full_messages}"

    @ba.tilino = 'short'
    assert @ba.valid?, "Only text should pass validation #{@ba.errors.full_messages}"

    @ba.tilino = 'short1'
    refute @ba.valid?, "Should fail#{@ba.errors.full_messages}"
  end

  test "should generate iban from account number" do
    @ba.tilino = '574044-25478'
    @ba.iban = ''
    assert @ba.save, @ba.errors.full_messages

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
