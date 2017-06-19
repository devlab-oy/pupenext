require 'test_helper'

class Reports::StockListingCsvControllerTest < ActionController::TestCase
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
      report_class: "StockListingCsv",
      report_params: { company_id: @bob.company.id, column_separator: ";" },
      report_name: "Varastosaldot CSV"
    }]

    ean_job_args = [{
      user_id: @bob.id,
      company_id: @bob.company.id,
      report_class: "StockListingEanCsv",
      report_params: { company_id: @bob.company.id, column_separator: ";" },
      report_name: "Varastosaldot EAN CSV"
    }]

    assert_enqueued_with(job: ReportJob, args: job_args) do
      assert_enqueued_with(job: ReportJob, args: ean_job_args) do
        post :run
        assert_redirected_to stock_listing_csv_path
        assert_not_equal "", flash.notice
      end
    end

    assert_enqueued_jobs 2
  end
end
