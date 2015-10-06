require 'test_helper'

class ReportJobTest < ActiveJob::TestCase
  test 'enqueues job' do
    assert_enqueued_jobs 0

    ReportJob.perform_later
    assert_enqueued_jobs 1
  end
end
