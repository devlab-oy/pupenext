class ReportsController < ApplicationController
  def revenue_expenditure
    @data = RevenueExpenditureReport.new(params[:period]).data if params[:period]
  end
end
