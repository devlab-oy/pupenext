class PendingProductUpdatesController < ApplicationController
  include ColumnSort

  def index

    @products = Product.all

    if search_params[:toim_tuoteno]
      @products = @products.joins(:product_suppliers).where("tuotteen_toimittajat.toim_tuoteno like ?", '%'+search_params[:toim_tuoteno]+'%')
      params[:toim_tuoteno] = ''
    end

    if search_params[:ei_saldoa]
      @products = @products.where(ei_saldoa: '')
      params[:ei_saldoa] = ''
    end

    if search_params[:poistettu]
      @products = @products.where(status: 'P')
      params[:poistettu] = ''
    end

    @products = @products.search_like(search_params)
  end

  private

    def pending_params
      params.permit(
        :tuoteno,
        :nimitys,
        :toim_tuoteno,
        :poistettu,
        :ei_saldoa,
        osasto: [],
        try: [],
        tuotemerkki: [],
      )
    end

    def sortable_columns
      [
        :tuoteno,
        :nimitys,
        :toim_tuoteno,
        :poistettu,
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
