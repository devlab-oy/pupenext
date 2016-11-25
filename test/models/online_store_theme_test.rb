require 'test_helper'

class OnlineStoreThemeTest < ActiveSupport::TestCase
  fixtures %w(
    online_store_themes
  )

  setup do
    @one = online_store_themes(:one)
    @two = online_store_themes(:two)
  end

  test 'fixtures are valid' do
    assert @one.valid?, @one.errors.full_messages
    assert @two.valid?, @two.errors.full_messages
  end

  test 'associations work' do
    assert_not_empty @one.online_stores
    assert_not_empty @two.online_stores
  end
end
