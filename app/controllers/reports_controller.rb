class ReportsController < ApplicationController
  def revenue_expenditure
    @data = RevenueExpenditureReport.new(params[:period].to_i).data if params[:period]
  end
end
