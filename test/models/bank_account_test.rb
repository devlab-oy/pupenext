require "test_helper"

class BankAccountTest < ActiveSupport::TestCase

  setup do
    @ba = bank_accounts(:acme_account)
  end

  test "fixtures should be valid" do
    assert @ba.valid?, @ba.errors.full_messages
  end

  test "duplicate accounts should fail" do
    two = @ba.dup
    refute two.valid?, two.errors.full_messages
  end

  test "should validate iban" do
    @ba.iban = "FI37-1590-3000-0007-76"
    assert @ba.valid?, "Should be a valid iban"
    assert_equal "FI3715903000000776", @ba.iban

    @ba.iban = "Keijon Kassatili"
    assert @ba.valid?, "Only text should bypass iban validation"
    assert_equal "KEIJONKASSATILI", @ba.iban

    @ba.iban = "NONO NOT A VALID IBAN3123"
    refute @ba.valid?, "Should not be valid with letters and few numbers"
  end

  test "should generate iban from account number" do
    @ba.iban = "574044-25478"

    assert @ba.valid?, "Should have generated IBAN from account number"
    assert_equal "FI0457404420005478", @ba.iban
  end

  test "should validate bic" do
    @ba.bic = 'DABAFIHH'
    assert @ba.valid?, "#{@ba.errors.full_messages}"

    @ba.bic = 'KEIJONBANK'
    refute @ba.valid?, "#{@ba.errors.full_messages}"
  end

  test "existence of all associated accounts is required" do
    @ba.oletus_rahatili = 9999

    refute @ba.valid?
  end

  test "existence of default liquidity account is required" do
    @ba.oletus_rahatili = 9999

    refute @ba.valid?
  end

  test "existence of default expense account is required" do
    @ba.oletus_kulutili = 9999

    refute @ba.valid?
  end

  test "existence of default clearing account is required" do
    @ba.oletus_selvittelytili = 9999

    refute @ba.valid?
  end


end
