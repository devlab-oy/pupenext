require 'test_helper'

class Reports::StockListingConfigurableCsvControllerTest < ActionController::TestCase
  include ActiveJob::TestHelper

  setup do
    @bob = users(:bob)
    login @bob
  end

  test 'test get report' do
    get :index
    assert_response :success
  end

  test 'test executing report' do
    assert_enqueued_jobs 0

    job_args = [{
      user_id: @bob.id,
      company_id: @bob.company.id,
      report_class: 'StockListingConfigurableCsv',
      report_params: { company_id: @bob.company.id, column_separator: ';' },
      report_name: 'Varastosaldot FIN CSV',
    }]

    assert_enqueued_with(job: ReportJob, args: job_args) do
      post :run
      assert_redirected_to stock_listing_configurable_csv_path
      assert_not_equal '', flash.notice
    end

    assert_enqueued_jobs 1
  end
end
