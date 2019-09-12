class Reports::StockListingSpecialCsvController < ApplicationController
  def index
  end

  def run

    ReportJob.perform_later(
      user_id: current_user.id,
      company_id: current_company.id,
      report_class: 'StockListingSpecialCsv',
      report_params: { company_id: current_company.id, column_separator: ';' },
      report_name: 'Varastosaldot puutteilla'
    )

    flash[:notice] = t('reports.stock_listing_csv.index.running')
    redirect_to stock_listing_special_csv_path
  end
end
