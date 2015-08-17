require "test_helper"

class KeywordTest < ActiveSupport::TestCase
  setup do
    @vat = keywords(:vat)
  end

  test "fixtures are valid" do
    assert @vat.valid?, @vat.errors.full_messages
  end
end
