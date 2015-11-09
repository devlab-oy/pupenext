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

    error = I18n.t 'errors.messages.inclusion'
    @delivery_method.vaihtoehtoinen_vak_toimitustapa = 'neko'
    refute @delivery_method.valid?
    assert_equal error, @delivery_method.errors[:vaihtoehtoinen_vak_toimitustapa].first
  end

  test 'unifaun info is present' do
    error = I18n.t 'errors.delivery_method.unifaun_info_missing'

    # If we have collective_batch and package_info_entry_denied we cannot use unifaun online
    @delivery_method.tulostustapa = :collective_batch
    @delivery_method.uudet_pakkaustiedot = :package_info_entry_denied
    @delivery_method.rahtikirja = :unifaun_online

    refute @delivery_method.valid?
    assert_equal error, @delivery_method.errors.messages[:base].first

    # If we have collective_batch and package_info_entry_denied we cannot use unifaun print server
    @delivery_method.rahtikirja = :unifaun_print_server
    refute @delivery_method.valid?
    assert_equal error, @delivery_method.errors.messages[:base].first

    # Not using unifaun is ok
    @delivery_method.rahtikirja = :generic_a4
    assert @delivery_method.valid?

    # Unifaun with package_info_entry_allowed is ok
    @delivery_method.rahtikirja = :unifaun_print_server
    @delivery_method.uudet_pakkaustiedot = :package_info_entry_allowed
    assert @delivery_method.valid?

    # Unifaun with batch is ok
    @delivery_method.uudet_pakkaustiedot = :package_info_entry_denied
    @delivery_method.tulostustapa = :batch
    assert @delivery_method.valid?
  end

  test 'should be in use' do
    assert_no_difference('DeliveryMethod.count') do
      @delivery_method.destroy
    end
  end

  test 'should update relations when updating selite' do
    # Set delivery method to all available relations
    dm = delivery_methods :kiitolinja
    dm.update! vak_kielto: @delivery_method.selite, vaihtoehtoinen_vak_toimitustapa: @delivery_method.selite

    cust = customers :stubborn_customer
    cust.update! toimitustapa: @delivery_method.selite

    cust_key = customer_keywords :keyword_1
    cust_key.update! avainsana: @delivery_method.selite

    order = sales_order_orders :not_delivered_order_1
    order.update! toimitustapa: @delivery_method.selite

    draft = sales_order_drafts :not_finished_order
    draft.update! toimitustapa: @delivery_method.selite

    stock = stock_transfer_orders :st_one
    stock.update! toimitustapa: @delivery_method.selite

    preorder = preorder_orders :pre_one
    preorder.update! toimitustapa: @delivery_method.selite

    offer = offer_order_orders :offer_one
    offer.update! toimitustapa: @delivery_method.selite

    manufacture = manufacture_order_orders :mo_one
    manufacture.update! toimitustapa: @delivery_method.selite

    work = work_order_orders :work_one
    work.update! toimitustapa: @delivery_method.selite

    project = project_order_orders :project_one
    project.update! toimitustapa: @delivery_method.selite

    reclamation = reclamation_order_orders :reclamation_one
    reclamation.update! toimitustapa: @delivery_method.selite

    freight = freights :kaukokiito_freight
    freight.update! toimitustapa: @delivery_method.selite

    freight_contract = freight_contracts :kaukokiito_freight_contract
    freight_contract.update! toimitustapa: @delivery_method.selite

    waybill = waybills :waybill_one
    waybill.update! toimitustapa: @delivery_method.selite

    # Change delivery method name
    new_name = 'Kaukokiito kolmoinen'
    @delivery_method.update! selite: new_name

    assert_not_equal "", @delivery_method.flash_notice

    # Should change everywhere
    assert_equal new_name, dm.reload.vak_kielto
    assert_equal new_name, dm.vaihtoehtoinen_vak_toimitustapa
    assert_equal new_name, cust.reload.toimitustapa
    assert_equal new_name, cust_key.reload.avainsana
    assert_equal new_name, order.reload.toimitustapa
    assert_equal new_name, draft.reload.toimitustapa
    assert_equal new_name, stock.reload.toimitustapa
    assert_equal new_name, preorder.reload.toimitustapa
    assert_equal new_name, offer.reload.toimitustapa
    assert_equal new_name, manufacture.reload.toimitustapa
    assert_equal new_name, work.reload.toimitustapa
    assert_equal new_name, project.reload.toimitustapa
    assert_equal new_name, reclamation.reload.toimitustapa
    assert_equal new_name, freight.reload.toimitustapa
    assert_equal new_name, freight_contract.reload.toimitustapa
    assert_equal new_name, waybill.reload.toimitustapa

    # Change something elsta than the delivery method name
    @delivery_method.update! virallinen_selite: new_name
    assert_equal "", @delivery_method.flash_notice
  end

  test 'should have departure' do
    assert_equal 1, @delivery_method.departures.count
  end
end
