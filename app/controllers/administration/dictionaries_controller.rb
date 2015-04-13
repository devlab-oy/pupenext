class Administration::DictionariesController < ApplicationController
  helper_method :languages

  def index
    if languages.empty?
      @dictionaries = Dictionary.none
    elsif strict_search
      @dictionaries = Dictionary.where(search_language => keywords)
    elsif search_language && keywords
      @dictionaries = Dictionary.where_like(search_language, keywords)
    elsif !valid_search_language
      @dictionaries = Dictionary.none
    else
      @dictionaries = Dictionary.all
    end
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

    def keywords
      return nil unless params[:search] && params[:search][:keyword].present?

      params[:search][:keyword]
    end

    def strict_search
      params[:search] && params[:search][:strict] && search_language && keywords
    end

    def valid_search_language
      return true unless params[:search] && params[:search][:language]

      params[:search] &&
        params[:search][:language] &&
        params[:search][:language].in?(Dictionary.all_languages.to_h.values)
    end
end
