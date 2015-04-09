require "test_helper"

class BankHelperTest < ActiveSupport::TestCase
  include BankHelper

  test "check_sepa returns correct codes for correct countries" do
    assert_equal 18, check_sepa("FI")
    assert_equal 22, check_sepa(:GB)
    assert_equal 27, check_sepa("GR")
  end

  test "check_sepa returns nil for incorrect country codes" do
    assert_nil check_sepa("Kala")
    assert_nil check_sepa(:Kala)
    assert_nil check_sepa("Finland")
    assert_nil check_sepa('')
    assert_nil check_sepa(0)
    assert_nil check_sepa(nil)
  end

  test "valid_iban? returns true for correct IBANs" do
    assert valid_iban?("NL91ABNA0417164300")
    assert valid_iban?("IT60X0542811101000000123456")
    assert valid_iban?("CY17002001280000001200527600")
  end

  test "valid_iban? returns true for values containing only letters" do
    assert valid_iban?("Kissa")
  end

  test "valid_iban? returns false for incorrect IBANs" do
    refute valid_iban?("Kala1")
    refute valid_iban?("CH93007620116238529578")
    refute valid_iban?("LV80BANK000045195001")
    refute valid_iban?("")
    refute valid_iban?(0)
    refute valid_iban?(nil)
  end

  test "valid_bic? returns true for valid BICs" do
    assert valid_bic?("NDEAFIHH")
    assert valid_bic?("NDEAEE2X")
    assert valid_bic?("DABADKKK")
    assert valid_bic?("UNCRITMM")
    assert valid_bic?("DSBACNBXSHA")
  end

  test "valid_bic? returns false for invalid BICs" do
    refute valid_bic?("Koira")
    refute valid_bic?("BNORPHMMM")
    refute valid_bic?("BSMLKLXXXX")
    refute valid_bic?("UNCRITM")
    refute valid_bic?("")
    refute valid_bic?(0)
    refute valid_bic?(nil)
  end

  test "valid_account_number? returns true for valid account numbers" do
    assert valid_account_number?("195035-98761")
    assert valid_account_number?("789528-123654")
    assert valid_account_number?("500015-281")
  end

  test "valid_account_number? returns true for values containing only letters" do
    assert valid_account_number?("Testing")
  end

  test "valid_account_number? returns false for invalid account numbers" do
    refute valid_account_number?("123")
    refute valid_account_number?("9a8s7df98a7sdf")
    refute valid_account_number?("22999-27377")
    refute valid_account_number?("")
    refute valid_account_number?(0)
    refute valid_account_number?(nil)
  end

  test "valid_luhn? returns true for valid luhns?" do
    assert valid_luhn?("79927398713")
    assert valid_luhn?("4240865613330743")
    assert valid_luhn?("5540770545999702")
  end

  test "valid_luhn? returns false invalid luhns?" do
    refute valid_luhn?("79927398710")
    refute valid_luhn?("123456")
    refute valid_luhn?("abs123")
    refute valid_luhn?("")
    refute valid_luhn?(0)
    refute valid_luhn?(nil)
  end

  test "pad_account_number pads account number properly" do
    assert_equal "50000110000238", pad_account_number("500001-1238")
  end

  test "pad_account_number returns the given value if it contains only letters" do
    assert_equal "a" * 6, pad_account_number("a" * 6)
  end

  test "pad_account returns value back if length is not between 6 and 14" do
    assert_equal "12345", pad_account_number(12345)
    assert_equal "123456789012345", pad_account_number("123456789012345")
    assert_equal "0", pad_account_number(0)
    assert_equal "", pad_account_number(nil)
    assert_equal "", pad_account_number("")
  end

  test "create_iban creates valid Finnish IBANs with valid account numbers" do
    assert_equal "FI2350000110000238", create_iban("500001-1238")
    assert_equal "FI7331313001000058", create_iban("31313001000058")
  end

  test "create_iban returns the string back if it only contains letters" do
    assert_equal "Kulutustili", create_iban("Kulutustili")
  end
end
