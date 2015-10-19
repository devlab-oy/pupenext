class Reports::CustomerPriceListsController < ApplicationController
  def index
  end

  def create
    return render "index" unless params[:commit].present?

    @products = Product.includes(:attachments).all

    if params[:target_type] == "1"
      @customer = Customer.find_by(tunnus: params[:target])

      unless @customer
        flash.now[:alert] = t('reports.customer_price_lists.index.customer_not_found')
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

      flash.now[:alert] = t('reports.customer_price_lists.index.no_filters_specified')
      return render "index"
    end

    if @products.empty?
      flash.now[:alert] = t('reports.customer_price_lists.index.products_not_found')
      return render "index"
    end

    ReportJob.perform_later(user_id:       current_user.id,
                            company_id:    current_company.id,
                            report_class:  'CustomerPriceListReport',
                            report_params: { company_id: current_company.id,
                                             user_id:    current_user.id,
                                             html:       render_to_string('report', layout: false),
                                             binary:     true },
                            report_name:   t('reports.customer_price_list.header'))

    redirect_to customer_price_lists_url, notice: t('reports.customer_price_list.running')
  end
end
