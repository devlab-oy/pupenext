class Reports::CustomerPriceListsController < ApplicationController
  def index
  end

  def create
    return render "index" unless params[:commit].present?

    if params[:product_filter]
      @products = Product.includes(:attachments).all

      if params[:osasto]
        @products = @products.where(osasto: params[:osasto])
      end

      if params[:try]
        @products = @products.where(try: params[:try])
      end
    else
      return redirect_to customer_price_lists_url,
                         alert: t('reports.customer_price_lists.index.no_filters_specified')
    end

    if params[:target_type] == "1"
      @customer = Customer.find_by(tunnus: params[:target])

      unless @customer
        return redirect_to customer_price_lists_url,
                           alert: t('reports.customer_price_lists.index.customer_not_found')
      end
    elsif params[:target_type] == "2"
      @customer_subcategory = params[:target]
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
