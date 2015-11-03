class Reports::CustomerPriceListsController < ApplicationController
  def create
    return render :index unless params[:commit].present?

    @products = Product.includes(:attachments).active

    if params[:target_type] == "1"
      @customer = Customer.find_by(tunnus: params[:target])

      unless @customer
        flash.now[:alert] = t('.customer_not_found')
        return render :index, status: :not_found
      end
    elsif params[:target_type] == "2"
      @customer_subcategory = params[:target]
    end

    if params[:osasto] || params[:try]
      @products = @products.where(osasto: params[:osasto]) if params[:osasto]
      @products = @products.where(try: params[:try]) if params[:try]
    elsif params[:contract_filter] != "2"
      flash.now[:alert] = t('.no_filters_specified')
      return render :index
    end

    if @products.empty?
      flash.now[:alert] = t('.products_not_found')
      return render :index
    end

    kit = PDFKit.new render_to_string(:report, layout: false),
                     header_right: "#{t('.page')} [page]/[toPage]"

    kit.stylesheets << Rails.root.join('app', 'assets', 'stylesheets', 'reports', 'pdf_styles.css')

    send_data kit.to_pdf,
              disposition: :inline,
              filename:    "#{t('.filename')}.pdf"
  end
end
