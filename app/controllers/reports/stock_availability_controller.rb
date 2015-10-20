class Reports::StockAvailabilityController < ApplicationController
  def index
    report_selection
    if params[:period].present?
      report = StockAvailability.new company_id: current_company.id, baseline_week: params[:period].to_i,
        constraints: parse_constraints
      @data = report.to_screen

      kit = PDFKit.new(render_to_string(:to_pdf, layout: false), :page_size => 'Letter')
      pdf = kit.to_pdf
      file = kit.to_file('/tmp/kissa.pdf')
      flash[:notice] = t('reports.stock_availability.index.running')

      render :index
    end
  end

  def view_connected_sales_orders
    @orders = current_company.heads.sales_orders.find(params[:order_numbers])
  end

  private

    def report_selection
      @period_options = [4, 8, 16]
      @category_options = current_company.categories.pluck(:selitetark, :selite) || []
      @subcategory_options = current_company.subcategories.pluck(:selitetark, :selite) || []
      @brand_options = current_company.brands.pluck(:selite, :selite) || []
    end

    def parse_constraints
      {
        category: params[:product_category] || [],
        subcategory: params[:product_subcategory] || [],
        brand: params[:product_brand] || []
      }
    end
end
