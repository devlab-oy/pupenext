require 'test_helper'

class IncomingMailTest < ActiveSupport::TestCase
  fixtures %w(
    companies
    incoming_mails
    mail_servers
  )

  test 'fixtures are valid' do
    IncomingMail.all.each do |incoming_mail|
      assert incoming_mail.valid?, incoming_mail.errors.full_messages
    end
  end

  test 'associations' do
    assert_equal companies(:acme),   mail_servers(:one).company
    assert_equal mail_servers(:one), incoming_mails(:one).mail_server
  end

  test 'status enum works' do
    assert_nothing_raised       { incoming_mails(:one).status = :ok    }
    assert_raise(ArgumentError) { incoming_mails(:one).status = :kissa }
  end

  test '#mail' do
    assert incoming_mails(:one).mail.is_a?(Mail::Message)

    incoming_mails(:one).raw_source = nil
    incoming_mails(:one).save(validate: false)
    assert incoming_mails(:one).reload.mail.is_a?(Mail::Message)
  end

  test '#subject' do
    assert_nil incoming_mails(:one).subject

    incoming_mails(:one).mail.subject = 'Test subject'
    assert_equal 'Test subject', incoming_mails(:one).subject
  end
end
