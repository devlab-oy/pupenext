class PendingProductUpdatesController < ApplicationController
  include ColumnSort

  before_action :find_resource, only: [:update]

  def index
  end

  def list
    render :index and return if params[:commit].blank?

    products = Product.regular
    products = products.where(nakyvyys: 'K') if params[:only_catalog]

    if search_params['tuotteen_toimittajat.toim_tuoteno']
      products = products.joins(:product_suppliers)
    end

    @products = products.search_like(search_params)
  end

  def list_of_changes
    @products = Product.regular.joins(:pending_updates).group(:tuoteno).order(:tuoteno)

    if @products.present?
      render :list
    else
      redirect_to pending_product_updates_path, notice: t('.not_found')
    end
  end

  def update
    @product.update pending_update_params

    respond_to do |format|
      format.html { redirect_to pending_product_updates_path }
      format.js
    end
  end

  def to_product
    ids = to_product_params[:product_ids]
    result = UpdatePendingProducts.new(company_id: current_company.id, product_ids: ids).update

    message = t('.updated', count: result.update_count)

    if result.failed_count.nonzero?
      message << ' ' + t('.failed', count: result.failed_count, errors: result.errors.join(', '))
    end

    redirect_to pending_product_updates_path, notice: message
  end

  def gallery
    attachment = Attachment::ProductAttachment.images.find params[:id]
    send_data attachment.data, disposition: 'inline', type: attachment.filetype
  end

  private

    def find_resource
      @product = Product.find params[:id]
    end

    def pending_update_params
      params.require(:product).permit(
        pending_updates_attributes: [ :id, :key, :value, :_destroy ],
      )
    end

    def to_product_params
      params.require(:pending_update).permit(
        product_ids: [],
      )
    end

    def sortable_columns
      [
        :tuoteno,
        :nimitys,
        'tuotteen_toimittajat.toim_tuoteno',
        :status,
        :ei_saldoa,
        osasto: [],
        try: [],
        tuotemerkki: [],
      ]
    end

    def searchable_columns
      sortable_columns
    end
end
