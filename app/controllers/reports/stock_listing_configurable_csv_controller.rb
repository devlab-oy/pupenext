class Reports::StockListingConfigurableCsvController < ApplicationController
  def run
    ReportJob.perform_later(
      user_id: current_user.id,
      company_id: current_company.id,
      report_class: 'StockListingConfigurableCsv',
      report_params: { company_id: current_company.id, column_separator: ';' },
      report_name: t('reports.stock_listing_configurable_csv.index.header'),
    )

    flash[:notice] = t('reports.stock_listing_csv.index.running')
    redirect_to stock_listing_configurable_csv_path
  end
end
