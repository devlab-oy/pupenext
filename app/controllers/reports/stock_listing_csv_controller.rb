class Reports::StockListingCsvController < ApplicationController
  def index
  end

  def run
    ReportJob.perform_later(
      user_id: current_user.id,
      company_id: current_company.id,
      report_class: 'StockListingCsv',
      report_params: { company_id: current_company.id },
      report_name: t('reports.stock_listing_csv.index.header')
    )

    flash[:notice] = t('reports.stock_listing_csv.index.running')
    redirect_to stock_listing_csv_path
  end
end
