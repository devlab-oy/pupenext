class Reports::StockAvailabilityController < ApplicationController
  before_action :report_selection, only: [:index]

  def index
    run_report(params[:period])
  end

  def run
    run_report(params[:period])
    if @data
      kit = PDFKit.new(render_to_string(:to_pdf, layout: false), :page_size => 'Letter')
      kit.stylesheets << Rails.root.join('app', 'assets', 'stylesheets', 'report.css')

      options = {
        filename: 'stock_availability.pdf',
        type: 'application/pdf'
      }

      send_data kit.to_pdf, options
    else
      redirect_to stock_availability_path
    end
  end

  def to_worker
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
    if params[:order_numbers].present?
      @orders = current_company.heads.sales_orders.find(params[:order_numbers])
    else
      render nothing: true
    end
  end

  def read_access?
    @read_access ||= current_user.can_read?("/stock_availability", classic: false)
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

    def run_report(period)
      return false unless period.present?
      report = StockAvailability.new company_id: current_company.id, baseline_week: period.to_i,
        constraints: parse_constraints

      @data = report.to_screen
    end
end
