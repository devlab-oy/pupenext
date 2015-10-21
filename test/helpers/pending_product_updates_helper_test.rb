require 'test_helper'

class PendingProductUpdatesHelperTest < ActionView::TestCase
  test "returns translated ei saldoa options valid for collection" do
    assert pending_ei_saldoa_options.is_a? Array

    text = I18n.t "pending_product_updates.pending_ei_saldoa_options.no_inventory_management"
    assert_equal text, pending_ei_saldoa_options.second.first
    assert_equal '@o', pending_ei_saldoa_options.second.second
  end

  test "returns translated status options valid for collection" do
    assert pending_status_options.is_a? Array

    text = I18n.t "pending_product_updates.pending_status_options.deleted"
    assert_equal text, pending_status_options.second.first
    assert_equal '@P', pending_status_options.second.second
  end

  test "returns translated columns options valid for collection" do
    assert pending_columns_options.is_a? Array

    text = I18n.t "pending_product_updates.pending_columns_options.shop_price"
    assert_equal text, pending_columns_options.second.first
    assert_equal 'myymalahinta', pending_columns_options.second.second
  end

  test "returns translated price options valid for collection" do
    assert pending_price_options.is_a? Array

    text = I18n.t "pending_product_updates.pending_price_options.shop_price"
    assert_equal text, pending_price_options.second.first
    assert_equal 'myymalahinta', pending_price_options.second.second
  end
end
