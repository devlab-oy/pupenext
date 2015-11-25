require 'test_helper'

class Keyword::CustomerPriceListAttributeTest < ActiveSupport::TestCase
  fixtures %w(keyword/customer_price_list_attributes)

  setup do
    @one = keyword_customer_price_list_attributes :one
  end

  test 'fixtures are valid' do
    assert @one.valid?, @one.errors.full_messages
  end

  test "selite can't be blank" do
    @one.selite = ""
    refute @one.valid?
  end

  test "selitetark can't be blank" do
    @one.selitetark = ""
    refute @one.valid?
  end
end
