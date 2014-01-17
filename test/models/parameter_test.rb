require 'test_helper'

class ParametersTest < ActiveSupport::TestCase

  def setup
    @acme_params = parameters(:acme)
  end

  test "fixture is valid" do
    assert @acme_params.valid?, @acme_params.errors.messages
  end

  test "params has a company" do
    assert_not_nil @acme_params.company
  end

end
