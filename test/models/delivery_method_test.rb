require 'test_helper'

class DeliveryMethodTest < ActiveSupport::TestCase
  def setup
    @delivery_method = delivery_methods(:kaukokiito)
  end

  test "fixtures should be valid" do
    assert @delivery_method.valid?, @delivery_method.errors.messages
  end

  test "selite should be unique" do
    @delivery_method.selite = "Kiitolinja"
    refute @delivery_method.valid?, "Delivery method already exists"
  end

  test 'should validate adr prohibition' do
    @delivery_method.vak_kielto = ''
    assert @delivery_method.valid?

    @delivery_method.vak_kielto = 'K'
    assert @delivery_method.valid?

    @delivery_method.vak_kielto = 'neko'
    refute @delivery_method.valid?, "Invalid vak_kielto value"
  end

  test 'should validate alternative adr prohibition' do
    @delivery_method.vaihtoehtoinen_vak_toimitustapa = ''
    assert @delivery_method.valid?

    @delivery_method.vaihtoehtoinen_vak_toimitustapa = 'neko'
    refute @delivery_method.valid?, "Invalid vaihtoehtoinen_vak_toimitustapa value"
  end
end
