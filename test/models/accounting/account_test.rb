require 'test_helper'

class Accounting::AccountTest < ActiveSupport::TestCase

  def setup
#    @account = accounting_accounts(:one_account_row)
  end

  test 'fixtures should be valid' do
    skip
    assert @account.valid?
  end
end
