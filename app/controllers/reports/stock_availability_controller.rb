class Reports::StockAvailabilityController < ApplicationController
  def index
  end

  def run
    ReportJob.perform_later(
      user_id: current_user.id,
      company_id: current_company.id,
      report_class: 'StockAvailablity',
      report_params: { company_id: current_company.id },
      report_name: t('reports.stock_availability.index.header')
    )

    flash[:notice] = t('reports.stock_availability.index.running')
    redirect_to stock_availability_path
  end
end
