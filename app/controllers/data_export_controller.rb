class DataExportController < ApplicationController
  include ColumnSort

  def product_keywords
  end

  def product_keywords_generate
    render :product_keywords and return if params[:commit].blank?

    @products = Product.regular.search_like(search_params)

    render json: @products
  end

  private

    def sortable_columns
      []
    end

    def searchable_columns
      [
        osasto: [],
        try: [],
        tuotemerkki: [],
      ]
    end
end
