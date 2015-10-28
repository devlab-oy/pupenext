class Reports::StockAvailabilityController < ApplicationController

  def index
  end

  def run
    redirect_to stock_availability_path(stock_params) and return if invalid_parameters?

    report = StockAvailability.new(
      company_id: current_company.id,
      baseline_week: stock_params[:period].to_i,
      constraints: parse_constraints
    )

    respond_to do |format|
      format.html do
        @data = report.to_screen
        render :index
      end

      format.pdf do
        html = render_to_string(:to_pdf, layout: false, formats: [:html])
        options = {
          filename: 'stock_availability.pdf',
          type: 'application/pdf'
        }
        send_data report.to_file(html), options
      end
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
        category: stock_params[:osasto] || [],
        subcategory: stock_params[:try] || [],
        brand: stock_params[:tuotemerkki] || []
      }
    end

    def stock_params
      params.permit(
        :period,
        osasto: [],
        try: [],
        tuotemerkki: [],
      )
    end

    def invalid_parameters?
      params[:commit].blank? || stock_params[:period].blank?
    end
end
