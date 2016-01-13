class Reports::DepreciationDifferenceController < ApplicationController
  def index
  end

  def create
    @report = Reports::Commodity.new(
      company_id: current_company.id,
      start_date: report_params[:start_date],
      end_date:   report_params[:end_date],
    )

    render :report
  end

  private

    def report_params
      params.permit(
        :start_date,
        :end_date
      )
    end
end
