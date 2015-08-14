class ReportsController < ApplicationController

  def index
  end

  def revenue_expenditure
    @data = RevenueExpenditureReport.new(params[:period].to_i).data if params[:period]
  end
end
