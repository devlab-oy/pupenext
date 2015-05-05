require 'test_helper'

class AccountHelperTest < ActionView::TestCase

  test "gives names" do
    assert_equal "Perustamismenot 120", account_name('120')
  end

  test "gives blank" do
    assert_equal "", account_name('not_a_account')
  end

end
