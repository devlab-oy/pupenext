class Reports::StockAvailabilityController < ApplicationController
  def index
    report_selection
    if params[:period].present?
      report = StockAvailability.new company_id: current_company.id, baseline_week: params[:period].to_i,
        constraints: parse_constraints
      @data = report.to_screen

      render :index
    end
  end

  def run
    report_selection
    if params[:period].present?
      report = StockAvailability.new company_id: current_company.id, baseline_week: params[:period].to_i,
        constraints: parse_constraints
      @data = report.to_screen

      kit = PDFKit.new(render_to_string(:to_pdf, layout: false), :page_size => 'Letter')
      kit.stylesheets << Rails.root.join('app', 'assets', 'stylesheets', 'report.css')

      options = {
        filename: 'stock_availability.pdf',
        type: 'application/pdf'
      }

      send_data kit.to_pdf, options
    end
  end

  def to_worker
    report_selection
    if params[:period].present?
      ReportJob.perform_later(
        user_id: current_user.id,
        company_id: current_company.id,
        report_class: 'StockAvailability',
        report_params: {
          company_id: current_company.id,
          baseline_week: params[:period].to_i,
          constraints: parse_constraints
        },
        report_name: t('reports.stock_availability.index.header')
      )

      flash[:notice] = t('reports.stock_availability.index.running')
      redirect_to stock_availability_path
    end
  end

  def view_connected_sales_orders
    @orders = current_company.heads.sales_orders.find(params[:order_numbers])
  end

  def read_access?
    @read_access ||= current_user.can_read?("/stock_availability", classic: false)
  end

  def update_access?
    @update_access ||= current_user.can_update?("/stock_availability", classic: false)
  end

  private

    def report_selection
      @period_options = 3..16
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
