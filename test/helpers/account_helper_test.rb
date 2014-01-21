require 'test_helper'

class AccountHelperTest < ActionView::TestCase

  test "gives names" do
    assert_equal "Pankkikortit", account_name('4001')
  end

  test "gives blank" do
    assert_equal "", account_name('not_a_account')
  end

end
