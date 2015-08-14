class ReportsController < ApplicationController

  def index
  end

  def revenue_expenditure
    @data = RevenueExpenditureReport.new(params[:period]).data if params[:period]
  end
end
