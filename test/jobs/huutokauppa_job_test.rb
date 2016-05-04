require 'minitest/mock'
require 'test_helper'

class HuutokauppaJobTest < ActiveJob::TestCase
  fixtures %w(
    customers
    delivery_methods
    incoming_mails
    mail_servers
    sales_order/drafts
    sales_order/orders
    sales_order/rows
  )

  test 'job is enqueued correctly' do
    assert_enqueued_jobs 0

    HuutokauppaJob.perform_later(id: incoming_mails(:three).id)

    assert_enqueued_jobs 1
  end

  test 'customer and product info are updated correctly to order when customer is found' do
    incoming_mail = incoming_mails(:three)

    incoming_mail.raw_source = huutokauppa_email(:offer_accepted_1)
    incoming_mail.save!

    assert_no_difference 'Customer.count' do
      HuutokauppaJob.perform_now(id: incoming_mail.id)
    end

    sales_order = SalesOrder::Draft.find_by!(viesti: 277_075)

    assert_equal 'Testi Testit Testitestit', sales_order.nimi
    assert_equal 665, sales_order.rows.first.rivihinta

    assert_equal 'ok', incoming_mail.reload.status
    assert_includes incoming_mail.reload.status_message, "Päivitettiin tilauksen #{sales_order.id} asiakastiedot."

    incoming_mail.raw_source = huutokauppa_email(:offer_automatically_accepted_1)
    incoming_mail.save!

    assert_no_difference 'Customer.count' do
      HuutokauppaJob.perform_now(id: incoming_mail.id)
    end

    sales_order = SalesOrder::Draft.find_by!(viesti: 270_265)

    assert_equal 'Test-testi Testite', sales_order.nimi
    assert_equal 300, sales_order.rows.first.rivihinta

    assert_equal 'ok', incoming_mail.reload.status
    assert_includes incoming_mail.reload.status_message, "Päivitettiin tilauksen #{sales_order.id} asiakastiedot."
  end

  test 'customer is created and customer and product info are updated correctly to order when customer is not found' do
    Customer.delete_all

    incoming_mail = incoming_mails(:three)

    incoming_mail.raw_source = huutokauppa_email(:offer_accepted_1)
    incoming_mail.save!

    assert_difference 'Customer.count' do
      HuutokauppaJob.perform_now(id: incoming_mail.id)
    end

    sales_order = SalesOrder::Draft.find_by!(viesti: 277_075)

    assert_equal 'Testi Testit Testitestit', sales_order.nimi
    assert_equal 665, sales_order.rows.first.rivihinta

    assert_equal 'ok', incoming_mail.reload.status
    assert_includes incoming_mail.reload.status_message, "Asiakas #{Customer.last.id} luotu."

    incoming_mail.raw_source = huutokauppa_email(:offer_automatically_accepted_1)
    incoming_mail.save!

    assert_difference 'Customer.count' do
      HuutokauppaJob.perform_now(id: incoming_mail.id)
    end

    sales_order = SalesOrder::Draft.find_by!(viesti: 270_265)

    assert_equal 'Test-testi Testite', sales_order.nimi
    assert_equal 300, sales_order.rows.first.rivihinta

    assert_equal 'ok', incoming_mail.reload.status
    messsage = "Päivitettiin tilauksen #{sales_order.id} rivin #{sales_order.rows.first.id} tuotetiedot"
    assert_includes incoming_mail.reload.status_message, messsage
  end

  test 'error is logged if exception is thrown' do
    Customer.delete_all
    Keyword::NatureOfTransaction.delete_all

    incoming_mail = incoming_mails(:three)

    incoming_mail.raw_source = huutokauppa_email(:offer_accepted_1)
    incoming_mail.save!

    HuutokauppaJob.perform_now(id: incoming_mail.id)

    assert_equal 'error', incoming_mail.reload.status
    assert_equal "undefined method `selite' for nil:NilClass", incoming_mail.reload.status_message
  end

  test 'order is marked as done correctly and delivery type set to nouto when no info about delivery' do
    incoming_mail = incoming_mails(:three)

    incoming_mail.raw_source = huutokauppa_email(:purchase_price_paid_1)
    incoming_mail.save!

    draft = sales_order_drafts(:huutokauppa_270265)

    mark_as_done = proc do
      draft.tila = 'L'
      draft.save(validate: false)
    end

    LegacyMethods.stub(:pupesoft_function, mark_as_done) do
      assert_difference 'SalesOrder::Draft.count', -1 do
        HuutokauppaJob.perform_now(id: incoming_mail.id)
      end
    end

    order = SalesOrder::Order.find_by!(viesti: 270_265)

    assert_equal delivery_methods(:nouto), order.delivery_method

    assert_equal 'ok', incoming_mail.reload.status
    assert_includes incoming_mail.reload.status_message, "Päivitettiin tilauksen #{order.id} toimitustavaksi Nouto."
  end

  test 'order delivery info is updated and delivery method set when type is delivery ordered' do
    incoming_mail = incoming_mails(:three)

    draft = sales_order_drafts(:huutokauppa_274472)
    draft.tila = 'L'
    draft.save(validate: false)

    incoming_mail.raw_source = huutokauppa_email(:delivery_ordered_1)
    incoming_mail.save!

    HuutokauppaJob.perform_now(id: incoming_mail.id)

    order = SalesOrder::Order.find_by!(viesti: 274_472)

    assert_equal 'Test-testi testit Testites',         order.toim_nimi
    assert_equal delivery_methods(:itella_economy_16), order.delivery_method

    assert_equal 'ok', incoming_mail.reload.status
    assert_includes incoming_mail.reload.status_message, "Päivitettiin tilauksen #{order.id} toimitustiedot."
  end
end
