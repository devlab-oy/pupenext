class Reports::CustomerPriceListsController < ApplicationController
  def create
    return render :index, formats: :html unless params[:commit].present?

    unless params[:osasto] || params[:try]
      flash.now[:alert] = t('.no_filters_specified')
      return render :index, formats: :html
    end

    @products = Product.active

    case params[:target_type].to_i
    when 1 # Customer
      @customer = Customer.find_by(tunnus: params[:target])

      unless @customer
        flash.now[:alert] = t('.customer_not_found')
        return render :index, status: :not_found, formats: :html
      end
    when 2 # Customer subcategory
      @customer_subcategory = params[:target]
    else
      return render :index, status: :bad_request, formats: :html
    end

    @products = @products.where(osasto: params[:osasto]) if params[:osasto]
    @products = @products.where(try: params[:try]) if params[:try]

    if @products.empty?
      flash.now[:alert] = t('.products_not_found')
      return render :index, formats: :html
    end

    render pdf:              t('.filename'),
           template:         'reports/customer_price_lists/report.html.erb',
           user_style_sheet: Rails.root.join('app',
                                             'assets',
                                             'stylesheets',
                                             'reports',
                                             'pdf_styles.css'),
           header:           { right: "#{t('.page')} [page] / [toPage]" },
           footer:           { html: { template: 'reports/customer_price_lists/footer.html.erb' } }
  end
end
