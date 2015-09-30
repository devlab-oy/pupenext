class PendingProductUpdatesController < ApplicationController
  include ColumnSort

  def index
  end

  def list
    @products = Product.all

    if search_params['tuotteen_toimittajat.toim_tuoteno']
      @products = @products.joins(:product_suppliers).search_like(search_params)
    end

    @products = @products.search_like(search_params)
  end

  private

    def pending_params
      params.permit(
        :tuoteno,
        :nimitys,
        'tuotteen_toimittajat.toim_tuoteno',
        :status,
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
