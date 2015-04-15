class Administration::DictionariesController < ApplicationController
  helper_method :languages
  helper_method :search_language
  helper_method :strict_search?
  helper_method :keyword
  helper_method :untranslated?

  def index
    if languages.empty? || !valid_search_language
      flash.now[:alert] = "Valitse käännettävä kieli" if params[:commit]
      return @dictionaries = Dictionary.none
    end

    if strict_search?
      @dictionaries = Dictionary.where(search_language => keywords)
    elsif search_language && keywords.present?
      @dictionaries = Dictionary.search_or(search_language, keywords)
    else
      @dictionaries = Dictionary.all
    end

    filter_translated

    @dictionaries = @dictionaries.order({ luontiaika: :desc }, :fi)
  end

  def bulk_update
    @dictionaries = Dictionary.where(tunnus: params[:dictionaries].keys)

    @dictionaries.each do |dictionary|
      dictionary.update_by dictionaries_params[dictionary.tunnus.to_s], current_user
    end

    filter_translated

    @dictionaries = @dictionaries.order({ luontiaika: :desc }, :fi)

    render :index
  end

  private

    def languages
      return [] unless params[:languages]

      params[:languages].select { |l| l.in? Dictionary.allowed_languages.to_h.values }
    end

    def search_language
      return nil unless params[:search] && params[:search][:language]

      if params[:search][:language].in?(Dictionary.all_languages.to_h.values)
        params[:search][:language]
      end
    end

    def keyword
      return "" unless params[:search] && params[:search][:keyword].present?

      params[:search][:keyword]
    end

    def keywords
      keyword.split("\n")
    end

    def strict_search?
      params[:search] &&
        params[:search][:strict] == "true" &&
        search_language.present? &&
        keywords.present?
    end

    def valid_search_language
      return true unless params[:search] && params[:search][:language]

      params[:search] &&
        params[:search][:language] &&
        params[:search][:language].in?(Dictionary.all_languages.to_h.values)
    end

    def dictionaries_params
      params.require(:dictionaries).permit!
    end

    def filter_translated
      if params[:untranslated] && params[:untranslated] == "true"
        conditions = languages.map { |language| "#{language} = ''" }
        conditions = conditions.join(" OR ")
        @dictionaries = @dictionaries.where(conditions)
      end
    end

    def untranslated?
      !params[:untranslated] || (params[:untranslated] && params[:untranslated] == "true")
    end
end
