require 'test_helper'

class MailServerTest < ActiveSupport::TestCase
  fixtures %w(
    companies
    incoming_mails
    mail_servers
  )

  test 'fixtures are valid' do
    MailServer.all.each do |mail_server|
      assert mail_server.valid?, mail_server.errors.full_messages
    end
  end

  test 'associations' do
    refute_empty mail_servers(:one).incoming_mails
    assert_equal companies(:acme), mail_servers(:one).company
  end
end
