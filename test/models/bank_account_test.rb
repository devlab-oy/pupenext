require 'test_helper'

class BankAccountTest < ActiveSupport::TestCase
  def setup
    @ba = bank_accounts(:acme_account)
  end

  test "fixtures should be valid" do
    assert @ba.valid?
  end

end