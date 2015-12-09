class Reports::TalgrafBalancesCsvController < ApplicationController
  def index
  end

  def run
    ReportJob.perform_later(
      user_id: current_user.id,
      company_id: current_company.id,
      report_class: 'TalgrafBalancesCsv',
      report_params: { company_id: current_company.id },
      report_name: t('reports.talgraf_balances_csv.index.header')
    )

    flash[:notice] = t('reports.talgraf_balances_csv.index.running')
    redirect_to talgraf_balances_csv_path
  end
end
