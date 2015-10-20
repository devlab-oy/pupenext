require 'test_helper'

class ReportFtpJobTest < ActiveJob::TestCase
  test 'enqueues job' do
    assert_enqueued_jobs 0

    ReportFtpJob.perform_later
    assert_enqueued_jobs 1
  end
end
