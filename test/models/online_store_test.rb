require 'test_helper'

class OnlineStoreTest < ActiveSupport::TestCase
  fixtures %w(
    online_store_themes
    online_stores
    products
  )

  setup do
    @pupeshop = online_stores(:pupeshop)
    @magento  = online_stores(:magento)

    @theme_one = online_store_themes(:one)
    @theme_two = online_store_themes(:two)
  end

  test 'fixtures are valid' do
    assert @pupeshop.valid?, @pupeshop.errors.full_messages
    assert @magento.valid?,  @magento.errors.full_messages
  end

  test 'associations work' do
    assert_equal @theme_one, @pupeshop.theme
    assert_equal @theme_two, @magento.theme

    assert_not_empty @pupeshop.products
    assert_not_empty @magento.products

    assert_equal companies(:acme), @pupeshop.company
    assert_equal companies(:acme), @magento.company
  end

  test 'STI works' do
    assert_instance_of OnlineStore::Pupeshop, @pupeshop
    assert_instance_of OnlineStore::Magento,  @magento
  end
end
