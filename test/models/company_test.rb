require 'test_helper'

class CompanyTest < ActiveSupport::TestCase

  def setup
    @acme = companies(:acme)
  end

  test "fixture is valid" do
    assert @acme.valid?
  end

  test "company has users" do
    assert_not_nil @acme.users
  end

  test "company has parameter(s)" do
    assert_not_nil @acme.parameter
  end

end
