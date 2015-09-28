require 'test_helper'

class FtpSendJobTest < ActiveJob::TestCase
  test 'enqueues job' do
    assert_enqueued_jobs 0

    FtpSendJob.perform_later
    assert_enqueued_jobs 1
  end
end
