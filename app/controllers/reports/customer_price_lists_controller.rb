class Reports::CustomerPriceListsController < ApplicationController
  def index
  end

  def create
    return render "index" unless params[:commit].present?

    @products = Product.includes(:attachments).all

    if params[:target_type] == "1"
      @customer = Customer.find_by(tunnus: params[:target])

      unless @customer
        flash.now[:alert] = t('.customer_not_found')
        return render "index", status: :not_found
      end

      if params[:contract_filter] == "2"
        @products = @customer.products
      end
    elsif params[:target_type] == "2"
      @customer_subcategory = params[:target]
    end

    if params[:osasto] || params[:try]
      if params[:osasto]
        @products = @products.where(osasto: params[:osasto])
      end

      if params[:try]
        @products = @products.where(try: params[:try])
      end
    elsif params[:contract_filter] != "2"
      flash.now[:alert] = t('.no_filters_specified')
      return render "index"
    end

    if @products.empty?
      flash.now[:alert] = t('.products_not_found')
      return render "index"
    end

    kit = PDFKit.new render_to_string('report', layout: false),
                     header_right: "#{t('.page')} [page]/[toPage]"

    kit.stylesheets << Rails.root.join('app', 'assets', 'stylesheets', 'report.css')

    send_data kit.to_pdf,
              disposition: :inline,
              filename:    "#{t('.filename')}.pdf"
  end
end
