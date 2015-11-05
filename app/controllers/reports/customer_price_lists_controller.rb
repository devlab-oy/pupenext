class Reports::CustomerPriceListsController < ApplicationController
  def create
    return render :index unless params[:commit].present?

    unless params[:osasto] || params[:try]
      flash.now[:alert] = t('.no_filters_specified')
      return render :index
    end

    @products = Product.includes(:attachments).active

    case params[:target_type].to_i
    when 1 # Customer
      @customer = Customer.find_by(tunnus: params[:target])

      unless @customer
        flash.now[:alert] = t('.customer_not_found')
        return render :index, status: :not_found
      end
    when 2 # Customer subcategory
      @customer_subcategory = params[:target]
    else
      return render :index, status: :bad_request
    end

    @products = @products.where(osasto: params[:osasto]) if params[:osasto]
    @products = @products.where(try: params[:try]) if params[:try]

    if @products.empty?
      flash.now[:alert] = t('.products_not_found')
      return render :index
    end

    kit = PDFKit.new render_to_string(:report, layout: false),
                     header_right: "#{t('.page')} [page]/[toPage]"

    kit.stylesheets << Rails.root.join('app', 'assets', 'stylesheets', 'reports', 'pdf_styles.css')

    send_data kit.to_pdf, filename: "#{t('.filename')}.pdf"
  end
end
