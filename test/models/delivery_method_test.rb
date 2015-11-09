require 'test_helper'

class DeliveryMethodTest < ActiveSupport::TestCase
  fixtures %w(
    customer_keywords
    customers
    delivery_method/departures
    delivery_methods
    freight_contracts
    freights
    heads
    locations
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
    @delivery_method = delivery_methods :kaukokiito
    @departure = delivery_method_departures :departure_one
  end

  test 'relations' do
    assert @delivery_method.customer_keywords.count > 0
    assert @delivery_method.customs.count > 0
    assert @delivery_method.departures.count > 0
    assert @delivery_method.freight_contracts.count > 0
    assert @delivery_method.freights.count > 0
    assert @delivery_method.locations.count > 0
    assert @delivery_method.manufacture_orders.count > 0
    assert @delivery_method.mode_of_transports.count > 0
    assert @delivery_method.nature_of_transactions.count > 0
    assert @delivery_method.offer_orders.count > 0
    assert @delivery_method.preorders.count > 0
    assert @delivery_method.project_orders.count > 0
    assert @delivery_method.reclamation_orders.count > 0
    assert @delivery_method.sales_order_drafts.count > 0
    assert @delivery_method.sales_orders.not_delivered.count > 0
    assert @delivery_method.sorting_point.count > 0
    assert @delivery_method.stock_transfers.not_delivered.count > 0
    assert @delivery_method.translations.count > 0
    assert @delivery_method.waybills.count > 0
    assert @delivery_method.work_orders.count > 0
  end

  test "fixtures should be valid" do
    assert @delivery_method.valid?, @delivery_method.errors.messages
    assert @departure.valid?, @departure.errors.full_messages
  end

  test 'departure should have valid time' do
    assert_equal '12:00:00', @departure.kerailyn_aloitusaika.strftime('%H:%M:%S'), @departure.errors.full_messages
    assert_equal '13:24:59', @departure.lahdon_kellonaika.strftime('%H:%M:%S'), @departure.errors.full_messages
  end

  test "selite should be unique" do
    @delivery_method.selite = "Kiitolinja"
    refute @delivery_method.valid?, "Delivery method already exists"
  end

  test 'valid vak_kielto values' do
    @delivery_method.vak_kielto = ''
    assert @delivery_method.valid?

    @delivery_method.vak_kielto = 'K'
    assert @delivery_method.valid?

    @delivery_method.vak_kielto = 'not valid'
    refute @delivery_method.valid?

    # should allow the name of any other delivery method that accepts adr
    dm = delivery_methods :kiitolinja
    dm.vak_kielto = ''
    dm.save!

    @delivery_method.vak_kielto = dm.selite
    assert @delivery_method.valid?

    # should NOT allow the name of delivery method if it does not accept adr
    dm.vak_kielto = 'K'
    dm.save!

    refute @delivery_method.valid?
  end

  test 'should not allow changing vak_kielto if used as alternative adr method' do
    # set kaukokiito to allow adr shipments
    @delivery_method.vak_kielto = ''
    @delivery_method.save!

    # set kiitolinja to have kaukokiito as alternative adr shipping method
    dm = delivery_methods :kiitolinja
    dm.vaihtoehtoinen_vak_toimitustapa = @delivery_method.selite
    dm.save!

    # try to change kaukokiito to deny adr shipments
    @delivery_method.vak_kielto = 'K'

    # should not be allowed
    error = I18n.t 'errors.delivery_method.in_use_adr'
    refute @delivery_method.valid?
    assert_equal error, @delivery_method.errors.messages[:vak_kielto].first
  end

  test 'should validate freight sku' do
    @delivery_method.rahti_tuotenumero = 'non_inventory_manageable_product'
    assert @delivery_method.valid?, @delivery_method.errors.full_messages

    error = I18n.t 'errors.delivery_method.product_not_in_inventory_management'
    @delivery_method.rahti_tuotenumero = 'hammer123'

    refute @delivery_method.valid?
    assert_equal error, @delivery_method.errors.messages[:rahti_tuotenumero].first
  end

  test 'should validate cargo insurance sku' do
    @delivery_method.kuljetusvakuutus_tuotenumero = 'non_inventory_manageable_product'
    assert @delivery_method.valid?

    error = I18n.t 'errors.delivery_method.product_not_in_inventory_management'
    @delivery_method.kuljetusvakuutus_tuotenumero = 'hammer123'

    refute @delivery_method.valid?
    assert_equal error, @delivery_method.errors.messages[:kuljetusvakuutus_tuotenumero].first
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

  test 'should have departure' do
    assert_equal 1, @delivery_method.departures.count
  end
end
