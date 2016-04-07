require 'test_helper'

class MailServerTest < ActiveSupport::TestCase
  test 'fixtures are valid' do
    MailServer.all.each do |mail_server|
      assert mail_server.valid?, mail_server.errors.full_messages
    end
  end
end
