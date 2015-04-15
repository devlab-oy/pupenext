class Administration::DictionariesController < ApplicationController
  helper_method :languages
  helper_method :search_language
  helper_method :strict_search?
  helper_method :keyword

  def index
    if languages.empty? || !valid_search_language
      @dictionaries = Dictionary.none
      return
    end

    if strict_search?
      @dictionaries = Dictionary.where(search_language => keyword)
    elsif search_language && keyword
      @dictionaries = Dictionary.where_like(search_language, keyword)
    else
      @dictionaries = Dictionary.all
    end

    if params[:untranslated] && params[:untranslated] == "true"
      conditions = languages.map { |language| "#{language} = ''" }
      conditions = conditions.join(" OR ")
      @dictionaries = @dictionaries.where(conditions)
    end
  end

  def create
    @dictionaries = Dictionary.find(params[:dictionaries].keys)

    @dictionaries.each do |dictionary|
      dictionary.update_by dictionaries_params[dictionary.tunnus.to_s], current_user
    end

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
      return nil unless params[:search] && params[:search][:keyword].present?

      params[:search][:keyword]
    end

    def strict_search?
      params[:search] &&
        params[:search][:strict] == "true" &&
        search_language.present? &&
        keyword.present?
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
end
