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
end
