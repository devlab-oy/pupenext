require 'test_helper'

class HuutokauppaJobTest < ActiveJob::TestCase
  fixtures %w(
    incoming_mails
    mail_servers
  )

  test 'job is enqueued correctly' do
    assert_enqueued_jobs 0

    HuutokauppaJob.perform_later(id: incoming_mails(:three).id)

    assert_enqueued_jobs 1
  end
end
