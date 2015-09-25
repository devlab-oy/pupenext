class ReportsController < ApplicationController
  def revenue_expenditure
    period = revenue_expenditure_params[:period].to_i

    @data = RevenueExpenditureReport.new(period).data unless period.zero?

    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  private

    def revenue_expenditure_params
      params.permit(
        :period,
      )
    end
end
