require 'test_helper'

class DeliveryMethodTest < ActiveSupport::TestCase
  fixtures %w(
    customer_keywords
    customers
    delivery_methods
    freight_contracts
    freights
    heads
    manufacture_order/orders
    offer_order/orders
    preorder/orders
    products
    project_order/orders
    reclamation_order/orders
    sales_order/drafts
    sales_order/orders
    stock_transfer/orders
    waybills
    work_order/orders
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

    deli2 = delivery_methods :kiitolinja
    deli2.vaihtoehtoinen_vak_toimitustapa = 'Kaukokiito'
    deli2.save!
    @delivery_method.vak_kielto = 'K'
    @delivery_method.save
    @delivery_method.vak_kielto = ''
    refute @delivery_method.valid?, @delivery_method.errors.full_messages
  end

  test 'should validate freight sku' do
    @delivery_method.rahti_tuotenumero = 'non_inventory_manageable_product'
    assert @delivery_method.valid?, @delivery_method.errors.full_messages

    @delivery_method.rahti_tuotenumero = 'hammer123'
    refute @delivery_method.valid?, @delivery_method.errors.full_messages
  end

  test 'should validate cargo insurance sku' do
    @delivery_method.kuljetusvakuutus_tuotenumero = 'non_inventory_manageable_product'
    assert @delivery_method.valid?, @delivery_method.errors.full_messages

    @delivery_method.kuljetusvakuutus_tuotenumero = 'hammer123'
    refute @delivery_method.valid?, @delivery_method.errors.full_messages
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
    deli2.vak_kielto = ''
    deli2.vaihtoehtoinen_vak_toimitustapa = @delivery_method.selite
    deli2.save!

    order = sales_order_orders :not_delivered_order_1
    order.toimitustapa = @delivery_method.selite
    order.save!

    draft = sales_order_drafts :not_finished_order
    draft.toimitustapa = @delivery_method.selite
    draft.save!

    stock = stock_transfer_orders :st_one
    stock.toimitustapa = @delivery_method.selite
    stock.save!

    preorder = preorder_orders :pre_one
    preorder.toimitustapa = @delivery_method.selite
    preorder.save!

    offer = offer_order_orders :offer_one
    offer.toimitustapa = @delivery_method.selite
    offer.save!

    manufacture = manufacture_order_orders :mo_one
    manufacture.toimitustapa = @delivery_method.selite
    manufacture.save!

    work = work_order_orders :work_one
    work.toimitustapa = @delivery_method.selite
    work.save!

    project = project_order_orders :project_one
    project.toimitustapa = @delivery_method.selite
    project.save!

    reclamation = reclamation_order_orders :reclamation_one
    reclamation.toimitustapa = @delivery_method.selite
    reclamation.save!

    freight = freights :kaukokiito_freight
    freight.toimitustapa = @delivery_method.selite
    freight.save!

    freight_contract = freight_contracts :kaukokiito_freight_contract
    freight_contract.toimitustapa = @delivery_method.selite
    freight_contract.save!

    waybill = waybills :waybill_one
    waybill.toimitustapa = @delivery_method.selite
    waybill.save!

    @delivery_method.selite = 'Kaukokiito3'
    @delivery_method.save!
    assert @delivery_method.valid?, @delivery_method.errors.full_messages

    # delivery_method
    deli2.reload
    assert_equal 'Kaukokiito3', deli2.vaihtoehtoinen_vak_toimitustapa

    # customers
    cust = customers :stubborn_customer
    assert_equal 'Kaukokiito3', cust.reload.toimitustapa

    # customer keywords
    cust_key = customer_keywords :keyword_1
    assert_equal 'Kaukokiito3', cust_key.reload.avainsana

    # sales orders
    assert_equal 'Kaukokiito3', order.reload.toimitustapa
    assert_equal 'Kaukokiito3', draft.reload.toimitustapa

    # stock transfer orders
    assert_equal 'Kaukokiito3', stock.reload.toimitustapa

    # stock transfer orders
    assert_equal 'Kaukokiito3', preorder.reload.toimitustapa

    # offer order orders
    assert_equal 'Kaukokiito3', offer.reload.toimitustapa

    # manufacture order orders
    assert_equal 'Kaukokiito3', manufacture.reload.toimitustapa

    # work order orders
    assert_equal 'Kaukokiito3', work.reload.toimitustapa

    # project order orders
    assert_equal 'Kaukokiito3', project.reload.toimitustapa

    # reclamation order orders
    assert_equal 'Kaukokiito3', reclamation.reload.toimitustapa

    # freights
    assert_equal 'Kaukokiito3', freight.reload.toimitustapa

    # freight_contract
    assert_equal 'Kaukokiito3', freight_contract.reload.toimitustapa

    # waybill
    assert_equal 'Kaukokiito3', waybill.reload.toimitustapa
  end
end
