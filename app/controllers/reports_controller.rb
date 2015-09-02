class ReportsController < ApplicationController

  def index
  end

  def revenue_expenditure
    @data = RevenueExpenditureReport.new(params[:period].to_i).data if params[:period]
  end

  def revenue_expenditure_update
    if RevenueExpenditureReport.update_keyword revenue_expenditure_params
      flash.now[:notice] = t('.update_success')
    end

    @data = RevenueExpenditureReport.new(params[:period].to_i).data if params[:period]
    render :revenue_expenditure
  end

  def revenue_expenditure_save
    if RevenueExpenditureReport.save_keyword revenue_expenditure_params
      flash.now[:notice] = t('.create_success')
    end

    @data = RevenueExpenditureReport.new(params[:period].to_i).data if params[:period]
    render :revenue_expenditure
  end

  def revenue_expenditure_delete
    if RevenueExpenditureReport.delete_keyword revenue_expenditure_params
      flash.now[:notice] = t('.delete_success')
    end

    @data = RevenueExpenditureReport.new(params[:period].to_i).data if params[:period]
    render :revenue_expenditure
  end

  private

    def revenue_expenditure_params
      params.permit(
        :period,
        :week,
        :name,
        :sum,
        :id,
      )
    end
end
