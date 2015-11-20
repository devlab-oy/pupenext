class Reports::CustomerPriceListsController < ApplicationController
  def create
    return render :index, formats: :html unless params[:commit].present?

    unless params[:osasto] || params[:try] || params[:tuotemerkki]
      flash.now[:alert] = t('.no_filters_specified')
      return render :index, formats: :html
    end

    @products = params[:product_image] ? Product.includes(:cover_thumbnail).active : Product.active

    @products = @products.where(osasto: params[:osasto]) if params[:osasto]
    @products = @products.where(try: params[:try]) if params[:try]
    @products = @products.where(tuotemerkki: params[:tuotemerkki]) if params[:tuotemerkki]

    case params[:target_type].to_i
    when 1 # Customer
      @customer = Customer.find_by(asiakasnro: params[:target])

      if @customer
        target = @customer
      else
        flash.now[:alert] = t('.customer_not_found')
        return render :index, status: :not_found, formats: :html
      end
    when 2 # Customer subcategory
      @customer_subcategory = Keyword::CustomerSubcategory.find_by(tunnus: params[:target])

      if @customer_subcategory
        target = @customer_subcategory
      else
        flash.now[:alert] = t('.customer_subcategory_not_found')
        return render :index, status: :not_found, formats: :html
      end
    else
      return render :index, status: :bad_request, formats: :html
    end

    if params[:contract_filter].to_i == 2
      @products = @products.select { |p| p.contract_price?(target) }
    end

    if @products.empty?
      flash.now[:alert] = t('.products_not_found')
      return render :index, formats: :html
    end

    render pdf:         t('.filename'),
           disposition: :attachment,
           footer:      { html: { template: 'reports/customer_price_lists/footer.html.erb' } },
           header:      { right: "#{t('.page')} [page] / [toPage]" },
           template:    'reports/customer_price_lists/report.html.erb'
  end
end
