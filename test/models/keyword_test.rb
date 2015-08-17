require "test_helper"

class KeywordTest < ActiveSupport::TestCase
  setup do
    @vat = keywords(:vat)
    @foreign_vat = keywords(:foreign_vat)
  end

  test "fixtures are valid" do
    assert @vat.valid?, @vat.errors.full_messages
    assert @foreign_vat.valid?, @foreign_vat.errors.full_messages
  end
end
