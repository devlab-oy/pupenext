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
    @kaukokiito = delivery_methods :kaukokiito
    @kiitolinja = delivery_methods :kiitolinja
    @departure = delivery_method_departures :departure_one

    # setup fixtures for all delivery method relations
    @cust        = customers :stubborn_customer
    @cust_key    = customer_keywords :keyword_1
    @order       = sales_order_orders :not_delivered_order_1
    @draft       = sales_order_drafts :not_finished_order
    @stock       = stock_transfer_orders :st_one
    @preorder    = preorder_orders :pre_one
    @offer       = offer_order_orders :offer_one
    @manufacture = manufacture_order_orders :mo_one
    @work        = work_order_orders :work_one
    @project     = project_order_orders :project_one
    @reclamation = reclamation_order_orders :reclamation_one
    @freight     = freights :kaukokiito_freight
    @contract    = freight_contracts :kaukokiito_freight_contract
    @waybill     = waybills :waybill_one
  end

  test 'relations' do
    assert @kaukokiito.customer_keywords.count > 0
    assert @kaukokiito.customs.count > 0
    assert @kaukokiito.departures.count > 0
    assert @kaukokiito.freight_contracts.count > 0
    assert @kaukokiito.freights.count > 0
    assert @kaukokiito.locations.count > 0
    assert @kaukokiito.manufacture_orders.count > 0
    assert @kaukokiito.mode_of_transports.count > 0
    assert @kaukokiito.nature_of_transactions.count > 0
    assert @kaukokiito.offer_orders.count > 0
    assert @kaukokiito.preorders.count > 0
    assert @kaukokiito.project_orders.count > 0
    assert @kaukokiito.reclamation_orders.count > 0
    assert @kaukokiito.sales_order_drafts.count > 0
    assert @kaukokiito.sales_orders.not_delivered.count > 0
    assert @kaukokiito.sorting_point.count > 0
    assert @kaukokiito.stock_transfers.not_delivered.count > 0
    assert @kaukokiito.translations.count > 0
    assert @kaukokiito.waybills.count > 0
    assert @kaukokiito.work_orders.count > 0
  end

  test "fixtures should be valid" do
    assert @kaukokiito.valid?, @kaukokiito.errors.messages
    assert @departure.valid?, @departure.errors.full_messages
  end

  test "selite should be unique" do
    error = I18n.t 'errors.messages.taken'
    @kaukokiito.selite = @kiitolinja.selite

    refute @kaukokiito.valid?
    assert_equal error, @kaukokiito.errors[:selite].first
  end

  test 'valid vak_kielto values' do
    @kaukokiito.vak_kielto = ''
    assert @kaukokiito.valid?

    @kaukokiito.vak_kielto = 'K'
    assert @kaukokiito.valid?

    @kaukokiito.vak_kielto = 'not valid'
    refute @kaukokiito.valid?

    # should allow the name of any other delivery method that accepts adr
    dm = delivery_methods :kiitolinja
    dm.update! vak_kielto: ''

    @kaukokiito.vak_kielto = dm.selite
    assert @kaukokiito.valid?

    # should NOT allow the name of delivery method if it does not accept adr
    dm.update! vak_kielto: 'K'

    refute @kaukokiito.valid?
  end

  test 'should not allow changing vak_kielto if used as alternative adr method' do
    # set kaukokiito to allow adr shipments
    @kaukokiito.update! vak_kielto: ''

    # set kiitolinja to have kaukokiito as alternative adr shipping method
    @kiitolinja.update! vaihtoehtoinen_vak_toimitustapa: @kaukokiito.selite

    # try to change kaukokiito to deny adr shipments
    @kaukokiito.vak_kielto = 'K'

    # should not be allowed
    error = I18n.t 'errors.delivery_method.in_use_adr'
    refute @kaukokiito.valid?
    assert_equal error, @kaukokiito.errors.messages[:vak_kielto].first
  end

  test 'should validate freight sku' do
    @kaukokiito.rahti_tuotenumero = 'non_inventory_manageable_product'
    assert @kaukokiito.valid?

    error = I18n.t 'errors.delivery_method.product_not_in_inventory_management'
    @kaukokiito.rahti_tuotenumero = 'hammer123'

    refute @kaukokiito.valid?
    assert_equal error, @kaukokiito.errors.messages[:rahti_tuotenumero].first
  end

  test 'should validate cargo insurance sku' do
    @kaukokiito.kuljetusvakuutus_tuotenumero = 'non_inventory_manageable_product'
    assert @kaukokiito.valid?

    error = I18n.t 'errors.delivery_method.product_not_in_inventory_management'
    @kaukokiito.kuljetusvakuutus_tuotenumero = 'hammer123'

    refute @kaukokiito.valid?
    assert_equal error, @kaukokiito.errors.messages[:kuljetusvakuutus_tuotenumero].first
  end

  test 'should validate alternative adr prohibition' do
    @kaukokiito.vaihtoehtoinen_vak_toimitustapa = ''
    assert @kaukokiito.valid?

    error = I18n.t 'errors.messages.inclusion'
    @kaukokiito.vaihtoehtoinen_vak_toimitustapa = 'neko'
    refute @kaukokiito.valid?
    assert_equal error, @kaukokiito.errors[:vaihtoehtoinen_vak_toimitustapa].first
  end

  test 'unifaun info is present' do
    error = I18n.t 'errors.delivery_method.unifaun_info_missing'

    # If we have collective_batch and package_info_entry_denied we cannot use unifaun online
    @kaukokiito.tulostustapa = :collective_batch
    @kaukokiito.uudet_pakkaustiedot = :package_info_entry_denied
    @kaukokiito.rahtikirja = :unifaun_online

    refute @kaukokiito.valid?
    assert_equal error, @kaukokiito.errors.messages[:base].first

    # If we have collective_batch and package_info_entry_denied we cannot use unifaun print server
    @kaukokiito.rahtikirja = :unifaun_print_server
    refute @kaukokiito.valid?
    assert_equal error, @kaukokiito.errors.messages[:base].first

    # Not using unifaun is ok
    @kaukokiito.rahtikirja = :generic_a4
    assert @kaukokiito.valid?

    # Unifaun with package_info_entry_allowed is ok
    @kaukokiito.rahtikirja = :unifaun_print_server
    @kaukokiito.uudet_pakkaustiedot = :package_info_entry_allowed
    assert @kaukokiito.valid?

    # Unifaun with batch is ok
    @kaukokiito.uudet_pakkaustiedot = :package_info_entry_denied
    @kaukokiito.tulostustapa = :batch
    assert @kaukokiito.valid?
  end

  test 'do not delete delivery method if it is in use' do
    # set kiitolinja delivery method for all available relations
    dm_name = @kiitolinja.selite
    @kaukokiito.update!  vak_kielto:   '', vaihtoehtoinen_vak_toimitustapa: ''
    @cust.update!        toimitustapa: dm_name
    @cust_key.update!    avainsana:    dm_name
    @order.update!       toimitustapa: dm_name
    @draft.update!       toimitustapa: dm_name
    @stock.update!       toimitustapa: dm_name
    @preorder.update!    toimitustapa: dm_name
    @offer.update!       toimitustapa: dm_name
    @manufacture.update! toimitustapa: dm_name
    @work.update!        toimitustapa: dm_name
    @project.update!     toimitustapa: dm_name
    @reclamation.update! toimitustapa: dm_name
    @freight.update!     toimitustapa: dm_name
    @contract.update!    toimitustapa: dm_name
    @waybill.update!     toimitustapa: dm_name

    kaukokiito = @kaukokiito.dup

    # We should be able to destroy kaukokiito, it's not used anywhere
    assert_difference('DeliveryMethod.count', -1) do
      @kaukokiito.destroy
    end

    # Let's get kaukokiito back
    kaukokiito.save!
    dm_name = kaukokiito.selite

    # Set kaukokiito as alternative adr for kiitolinja
    @kiitolinja.update! vak_kielto: dm_name
    error = I18n.t 'errors.delivery_method.in_use_delivery_method', count: 1

    refute kaukokiito.destroy
    assert_equal error, kaukokiito.errors.messages[:base].last

    # Set kaukokiito as alternative adr for kiitolinja
    @kiitolinja.update! vak_kielto: '', vaihtoehtoinen_vak_toimitustapa: dm_name

    refute kaukokiito.destroy
    assert_equal error, kaukokiito.errors.messages[:base].last

    # Set kaukokiito as default for customer
    @kiitolinja.update! vak_kielto: '', vaihtoehtoinen_vak_toimitustapa: ''
    @cust.update! toimitustapa: dm_name
    error = I18n.t 'errors.delivery_method.in_use_customers', count: 1

    refute kaukokiito.destroy
    assert_equal error, kaukokiito.errors.messages[:base].last

    # Set kaukokiito as default for customer keyword
    @cust.update! toimitustapa: ''
    @cust_key.update! avainsana: dm_name
    error = I18n.t 'errors.delivery_method.in_use_customer_keywords', count: 1

    refute kaukokiito.destroy
    assert_equal error, kaukokiito.errors.messages[:base].last

    # Set kaukokiito to an order
    @cust_key.update! avainsana: ''
    @order.update! toimitustapa: dm_name
    error = I18n.t 'errors.delivery_method.in_use_sales_orders', count: 1

    refute kaukokiito.destroy
    assert_equal error, kaukokiito.errors.messages[:base].last

    # Set kaukokiito to an order draft
    @order.update! toimitustapa: ''
    @draft.update! toimitustapa: dm_name
    error = I18n.t 'errors.delivery_method.in_use_sales_order_drafts', count: 1

    refute kaukokiito.destroy
    assert_equal error, kaukokiito.errors.messages[:base].last

    # Set kaukokiito to an stock transfer
    @draft.update! toimitustapa: ''
    @stock.update! toimitustapa: dm_name
    error = I18n.t 'errors.delivery_method.in_use_stock_transfers', count: 1

    refute kaukokiito.destroy
    assert_equal error, kaukokiito.errors.messages[:base].last

    # Set kaukokiito to an preorder
    @stock.update! toimitustapa: ''
    @preorder.update! toimitustapa: dm_name
    error = I18n.t 'errors.delivery_method.in_use_preorders', count: 1

    refute kaukokiito.destroy
    assert_equal error, kaukokiito.errors.messages[:base].last

    # Set kaukokiito to an offer
    @preorder.update! toimitustapa: ''
    @offer.update! toimitustapa: dm_name
    error = I18n.t 'errors.delivery_method.in_use_offer_orders', count: 1

    refute kaukokiito.destroy
    assert_equal error, kaukokiito.errors.messages[:base].last

    # Set kaukokiito to an manufacture order
    @offer.update! toimitustapa: ''
    @manufacture.update! toimitustapa: dm_name
    error = I18n.t 'errors.delivery_method.in_use_manufacture_orders', count: 1

    refute kaukokiito.destroy
    assert_equal error, kaukokiito.errors.messages[:base].last

    # Set kaukokiito to an workorder
    @manufacture.update! toimitustapa: ''
    @work.update! toimitustapa: dm_name
    error = I18n.t 'errors.delivery_method.in_use_work_orders', count: 1

    refute kaukokiito.destroy
    assert_equal error, kaukokiito.errors.messages[:base].last

    # Set kaukokiito to an project
    @work.update! toimitustapa: ''
    @project.update! toimitustapa: dm_name
    error = I18n.t 'errors.delivery_method.in_use_project_orders', count: 1

    refute kaukokiito.destroy
    assert_equal error, kaukokiito.errors.messages[:base].last

    # Set kaukokiito to an reclamation
    @project.update! toimitustapa: ''
    @reclamation.update! toimitustapa: dm_name
    error = I18n.t 'errors.delivery_method.in_use_reclamation_orders', count: 1

    refute kaukokiito.destroy
    assert_equal error, kaukokiito.errors.messages[:base].last

    # Set kaukokiito to an freight
    @reclamation.update! toimitustapa: ''
    @freight.update! toimitustapa: dm_name
    error = I18n.t 'errors.delivery_method.in_use_freights', count: 1

    refute kaukokiito.destroy
    assert_equal error, kaukokiito.errors.messages[:base].last

    # Set kaukokiito to an freight contract
    @freight.update! toimitustapa: ''
    @contract.update! toimitustapa: dm_name
    error = I18n.t 'errors.delivery_method.in_use_freight_contracts', count: 1

    refute kaukokiito.destroy
    assert_equal error, kaukokiito.errors.messages[:base].last

    # Set kaukokiito to an waybill
    @contract.update! toimitustapa: ''
    @waybill.update! toimitustapa: dm_name
    error = I18n.t 'errors.delivery_method.in_use_waybills', count: 1

    refute kaukokiito.destroy
    assert_equal error, kaukokiito.errors.messages[:base].last
  end

  test 'should update relations when updating selite' do
    # set delivery method to all available relations
    @kiitolinja.update!  vak_kielto:   @kaukokiito.selite, vaihtoehtoinen_vak_toimitustapa: @kaukokiito.selite
    @cust.update!        toimitustapa: @kaukokiito.selite
    @cust_key.update!    avainsana:    @kaukokiito.selite
    @order.update!       toimitustapa: @kaukokiito.selite
    @draft.update!       toimitustapa: @kaukokiito.selite
    @stock.update!       toimitustapa: @kaukokiito.selite
    @preorder.update!    toimitustapa: @kaukokiito.selite
    @offer.update!       toimitustapa: @kaukokiito.selite
    @manufacture.update! toimitustapa: @kaukokiito.selite
    @work.update!        toimitustapa: @kaukokiito.selite
    @project.update!     toimitustapa: @kaukokiito.selite
    @reclamation.update! toimitustapa: @kaukokiito.selite
    @freight.update!     toimitustapa: @kaukokiito.selite
    @contract.update!    toimitustapa: @kaukokiito.selite
    @waybill.update!     toimitustapa: @kaukokiito.selite

    # change the delivery method name
    new_name = 'Kaukokiito kakkoinen'
    @kaukokiito.update! selite: new_name

    # we should have a flash notice
    assert_not_empty @kaukokiito.flash_notice

    # should change everywhere
    assert_equal new_name, @kiitolinja.reload.vak_kielto
    assert_equal new_name, @kiitolinja.vaihtoehtoinen_vak_toimitustapa
    assert_equal new_name, @cust.reload.toimitustapa
    assert_equal new_name, @cust_key.reload.avainsana
    assert_equal new_name, @order.reload.toimitustapa
    assert_equal new_name, @draft.reload.toimitustapa
    assert_equal new_name, @stock.reload.toimitustapa
    assert_equal new_name, @preorder.reload.toimitustapa
    assert_equal new_name, @offer.reload.toimitustapa
    assert_equal new_name, @manufacture.reload.toimitustapa
    assert_equal new_name, @work.reload.toimitustapa
    assert_equal new_name, @project.reload.toimitustapa
    assert_equal new_name, @reclamation.reload.toimitustapa
    assert_equal new_name, @freight.reload.toimitustapa
    assert_equal new_name, @contract.reload.toimitustapa
    assert_equal new_name, @waybill.reload.toimitustapa

    # change something else than the delivery method name
    @kaukokiito.update! virallinen_selite: new_name

    # we should not have a flash notice
    assert_empty @kaukokiito.flash_notice
  end
end
