class PendingProductUpdatesController < ApplicationController
  include ColumnSort

  before_action :find_resource, only: [:create]

  def index
  end

  def list
    render :index and return if params[:commit].blank?

    products = Product.all

    if search_params['tuotteen_toimittajat.toim_tuoteno']
      products = products.joins(:product_suppliers)
    end

    @products = products.search_like(search_params)
  end

  def create
    @product.update pending_update_params

    redirect_to pending_product_updates_path
  end

  private

    def find_resource
      @product = Product.find params[:id]
    end

    def pending_update_params
      params.require(:pending_product_update).permit(
        pending_updates_attributes: [ :id, :key, :value, :_destroy ],
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
