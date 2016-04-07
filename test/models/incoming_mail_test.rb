require 'test_helper'

class IncomingMailTest < ActiveSupport::TestCase
  fixtures %w(
    incoming_mails
  )

  test 'fixtures are valid' do
    IncomingMail.all.each do |incoming_mail|
      assert incoming_mail.valid?, incoming_mail.errors.full_messages
    end
  end
end
