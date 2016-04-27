require 'test_helper'

class HuutokauppaJobTest < ActiveJob::TestCase
  fixtures %w(
    customers
    incoming_mails
    mail_servers
    sales_order/drafts
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

    incoming_mail.raw_source = huutokauppa_email(:offer_automatically_accepted_1)
    incoming_mail.save!

    assert_no_difference 'Customer.count' do
      HuutokauppaJob.perform_now(id: incoming_mail.id)
    end

    sales_order = SalesOrder::Draft.find_by!(viesti: 270_265)

    assert_equal 'Test-testi Testite', sales_order.nimi
    assert_equal 300, sales_order.rows.first.rivihinta
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

    incoming_mail.raw_source = huutokauppa_email(:offer_automatically_accepted_1)
    incoming_mail.save!

    assert_difference 'Customer.count' do
      HuutokauppaJob.perform_now(id: incoming_mail.id)
    end

    sales_order = SalesOrder::Draft.find_by!(viesti: 270_265)

    assert_equal 'Test-testi Testite', sales_order.nimi
    assert_equal 300, sales_order.rows.first.rivihinta
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
end
