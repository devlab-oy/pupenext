require 'test_helper'

class DeliveryMethodTest < ActiveSupport::TestCase
  fixtures %w(
    customer_keywords
    customers
    delivery_methods
    heads
    sales_order/orders
    sales_order/drafts
  )

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

  test 'mandatory new packaging information' do
    @delivery_method.tulostustapa = 'L'
    @delivery_method.uudet_pakkaustiedot = ''
    @delivery_method.rahtikirja = 'rahtikirja_unifaun_uo_siirto.inc'

    refute @delivery_method.valid?, "New packaging info is mandatory with collective batch and Unifaun Online"
  end

  test 'should be in use' do
    assert_no_difference('DeliveryMethod.count') do
      @delivery_method.destroy
    end
  end

  test 'should update relations when updating selite' do
    deli2 = @delivery_method.dup
    deli2.selite = 'Kaukokiito2'
    deli2.rahdinkuljettaja = 'Kaukokiito2'
    deli2.vak_kielto = @delivery_method.selite
    deli2.vaihtoehtoinen_vak_toimitustapa = @delivery_method.selite
    deli2.save!

    order = sales_order_orders :not_delivered_order_1
    order.toimitustapa = @delivery_method.selite
    order.save!

    draft = sales_order_drafts :not_finished_order
    draft.toimitustapa = @delivery_method.selite
    draft.save!

    assert_equal 'Kaukokiito', deli2.vak_kielto

    @delivery_method.selite = 'Kaukokiito3'
    @delivery_method.save!
    @delivery_method.reload
    assert @delivery_method.valid?, @delivery_method.errors.full_messages

    @delivery_method.relation_update

    # delivery_method
    assert_equal 'Kaukokiito3', deli2.reload.vak_kielto
    assert_equal 'Kaukokiito3', deli2.vaihtoehtoinen_vak_toimitustapa

    # # customers
    # cust = customers :stubborn_customer
    # assert_equal 'Kaukokiito3', cust.reload.toimitustapa

    # # customer keywords
    # cust_key = customer_keywords :keyword_1
    # puts "foo: #{cust_key.inspect}"
    # assert_equal 'Kaukokiito3', cust_key.reload.avainsana

    # # sales orders
    # assert_equal 'Kaukokiito3', order.reload.toimitustapa
    # assert_equal 'Kaukokiito3', draft.reload.toimitustapa
  end
end
