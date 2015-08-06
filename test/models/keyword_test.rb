require "test_helper"

class KeywordTest < ActiveSupport::TestCase
  setup do
    @one = keywords(:one)
  end

  test "vat_percent works" do
    assert_equal BigDecimal("24"), @one.vat_percent
  end

  test "vat_percent_text works" do
    assert_equal "24 %", @one.vat_percent_text
  end
end
