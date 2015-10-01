class Reports::StockListingCsvController < ApplicationController
  def index
  end

  def run
    ReportJob.perform_later(
      user_id: current_user.id,
      report_class: 'StockListingCsv',
      report_params: { company_id: current_company.id },
      report_name: 'Stock list'
    )

    flash[:notice] = 'Raporttia ajetaan! Valmis raporti löytyy omalta Download Areltasi'
    redirect_to stock_listing_csv_path
  end
end
