require 'test_helper'

class BankAccountTest < ActiveSupport::TestCase
  def setup
    @ba = bank_accounts(:acme_account)
  end

  test "fixtures should be valid" do
    assert @ba.valid?, "#{@ba.errors.full_messages}"
  end

  test "should validate iban" do
    @ba.iban = 'keijo'
    @ba.save
    refute @ba.valid?, "#{@ba.errors.full_messages}"
    assert_equal '', @ba.iban

    @ba.iban = 'GB82 WEST 1234 5698 7654 32'
    @ba.save
    assert_equal 22, @ba.iban.length
    assert @ba.valid?, "#{@ba.errors.full_messages}"

    @ba.iban = 'GB82 TEST 1234 5698 7654 32'
    @ba.save
    refute @ba.valid?, "#{@ba.errors.full_messages}"
    assert_equal '', @ba.iban
  end

  test "should validate account number" do
    @ba.tilino = '12345600000785'
    assert @ba.valid?, "#{@ba.errors.full_messages}"
    assert_equal '12345600000785', @ba.tilino

    @ba.tilino = '423456-781'
    assert @ba.valid?, "#{@ba.errors.full_messages}"
    assert_equal '42345670000081', @ba.tilino

    @ba.tilino = '923456-785'
    assert @ba.valid?, "#{@ba.errors.full_messages}"
    assert_equal '923456785', @ba.tilino

    @ba.tilino = 'Asdasdasd12313'
    refute @ba.valid?, "#{@ba.errors.full_messages}"
    assert_equal '', @ba.tilino

    @ba.tilino = ''
    refute @ba.valid?, "#{@ba.errors.full_messages}"
    assert_equal '', @ba.tilino
  end

  test "should generate iban from account number" do
    @ba.tilino = '423456-781'
    @ba.iban = ''
    @ba.save

    assert @ba.valid?
    assert_equal "FI5542345670000081", @ba.iban
  end

  test "should validate bic" do
    @ba.bic = 'DABAFIHH'
    @ba.save

    assert @ba.valid?, "#{@ba.errors.full_messages}"
  end

end
