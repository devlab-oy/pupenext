class ReportsController < ApplicationController
  def revenue_expenditure
    @data = RevenueExpenditureReport.new(params[:period].to_i).data if params[:period]
  end

  private

    def revenue_expenditure_params
      params.permit(
        :period,
      )
    end
end
