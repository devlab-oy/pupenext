require 'test_helper'

class IncomingMailJobTest < ActiveJob::TestCase
  test 'job is enqueued correctly' do
    assert_enqueued_jobs 0

    IncomingMailJob.perform_later

    assert_enqueued_jobs 1
  end
end
