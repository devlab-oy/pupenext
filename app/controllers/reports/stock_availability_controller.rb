class Reports::StockAvailabilityController < ApplicationController

  def index
    run_report(params[:period])
  end

  def run
    run_report(params[:period])
    if @data
      html = render_to_string(:to_pdf, layout: false)

      options = {
        filename: 'stock_availability.pdf',
        type: 'application/pdf'
      }

      send_data @report.to_file(html), options
    else
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

    def parse_constraints
      {
        category: params[:osasto] || [],
        subcategory: params[:try] || [],
        brand: params[:tuotemerkki] || []
      }
    end

    def run_report(period)
      render :index and return if params[:commit].blank?
      return false unless period.present?
      @report = StockAvailability.new company_id: current_company.id, baseline_week: period.to_i,
        constraints: parse_constraints
      @data = @report.to_screen
    end
end
