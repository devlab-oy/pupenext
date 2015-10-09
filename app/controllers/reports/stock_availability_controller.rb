class Reports::StockAvailabilityController < ApplicationController
  def index
    report_selection
    if params[:period].present?
      report = StockAvailability.new company_id: current_company.id, baseline_week: params[:period].to_i,
        constraints: parse_constraints
      @data = report.to_screen
      params.delete(:period)
      render :index
    end
  end

    def run
      ReportJob.perform_later(
        user_id: current_user.id,
        company_id: current_company.id,
        report_class: 'StockAvailability',
        report_params: { company_id: current_company.id, baseline_week: params[:baseline],
          constraints: parse_constraints },
        report_name: t('reports.stock_availability.index.header')
      )

      flash[:notice] = t('reports.stock_availability.index.running')
      redirect_to stock_availability_path
    end

  private

    def report_selection
      @period_options = [4, 8, 16]
      @category_options = current_company.categories.pluck(:selitetark, :selite)
      @subcategory_options = current_company.subcategories.pluck(:selitetark, :selite)
      @brand_options = current_company.brands.pluck(:selitetark, :selite)
    end

    def parse_constraints
      {
        category: params[:product_category] || [],
        subcategory: params[:product_subcategory] || [],
        brand: params[:product_brand] || []
      }
    end
end
