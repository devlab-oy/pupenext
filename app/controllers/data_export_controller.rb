class DataExportController < ApplicationController
  include ColumnSort

  def product_keywords
  end

  def product_keywords_generate
    render :product_keywords and return if params[:commit].blank?

    @products = Product.regular.includes(:keywords).search_like(search_params)

    respond_to do |format|
      format.xlsx { render :product_keywords }
    end
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
