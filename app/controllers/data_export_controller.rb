class DataExportController < ApplicationController
  include ColumnSort

  def product_keywords
  end

  def product_keywords_generate
    redirect_to product_keyword_export_path(keyword_params) and return if params[:commit].blank?

    @extra_fields = keyword_params[:extra_fields] || []
    @keywords = product_keywords
    @products = Product.regular.not_deleted.includes(:keywords).search_like(search_params)

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
        :language,
        :type,
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

    def product_keywords
      keywords = case keyword_params[:type]
      when 'keyword'
        Keyword::ProductKeywordType.all
      when 'information'
        Keyword::ProductInformationType.all
      when 'parameter'
        Keyword::ProductParameterType.all
      else
        Keyword.none
      end

      keywords.where(kieli: keyword_params[:language]).order(:jarjestys, :selitetark)
    end
end
