require 'test_helper'

class BankAccountTest < ActiveSupport::TestCase
  def setup
    @ba = bank_accounts(:acme_account)
  end

  test "fixtures should be valid" do
    assert @ba.valid?, "#{@ba.errors.full_messages}"
  end

  test "should validate iban" do
    @ba.iban = 'hassu hassu hassu joo'
    @ba.save
    assert_equal 18, @ba.iban.length
    assert @ba.valid?, "#{@ba.errors.full_messages}"
  end

end