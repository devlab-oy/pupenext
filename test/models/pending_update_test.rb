require 'test_helper'

class PendingUpdateTest < ActiveSupport::TestCase
  fixtures %w(products pending_updates)

  setup do
    @product = products :hammer
    @pending_update = pending_updates :update_1
  end

  test "assert fixtures are valid" do
    assert @product.valid?, @product.errors.messages
    assert @pending_update.valid?, @pending_update.errors.messages
  end

  test "assert fixture are invalid" do
    @pending_update.key = :nimitys
    @pending_update.value = ''
    refute @pending_update.valid?, @pending_update.errors.messages

    assert_equal 'Nimitys ei voi olla tyhjä', @pending_update.errors.first.second
  end

  test "should fail for scope" do
    pending_update_duplicate = @pending_update.dup

    refute pending_update_duplicate.valid?, pending_update_duplicate.errors.messages
    assert_equal 'on jo käytössä', pending_update_duplicate.errors.first.second
  end
end
