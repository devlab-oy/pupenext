require 'test_helper'

class OnlineStoreTypeTest < ActiveSupport::TestCase
  fixtures %w(
    online_store_types
  )

  setup do
    @one   = online_store_types(:one)
    @two   = online_store_types(:two)
    @three = online_store_types(:three)
  end

  test 'fixtures are valid' do
    assert @one.valid?,   @one.errors.full_messages
    assert @two.valid?,   @two.errors.full_messages
    assert @three.valid?, @three.errors.full_messages
  end
end
