class DataExportController < ApplicationController
  include ColumnSort

  def product_keywords
  end

  def product_keywords_generate
    redirect_to product_keyword_export_path(keyword_params) and return if params[:commit].blank?

    @extra_fields = keyword_params[:extra_fields]
    @products = Product.regular.includes(:keywords).search_like(search_params)

    respond_to do |format|
      format.xlsx { render :product_keywords }
    end
  end

  private

    def sortable_columns
      []
    end

    def keyword_params
      params.permit(
        extra_fields: [],
        osasto: [],
        try: [],
        tuotemerkki: [],
      )
    end

    def searchable_columns
      [
        osasto: [],
        try: [],
        tuotemerkki: [],
      ]
    end
end
