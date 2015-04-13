class Administration::DictionariesController < ApplicationController
  def index
    if languages.empty?
      @dictionaries = current_company.dictionaries.none
    elsif params[:search] && params[:search][:strict]
      @dictionaries = current_company
                        .dictionaries
                        .where(params[:search][:language] => params[:search][:keyword])
    elsif params[:search]
      @dictionaries = current_company
                        .dictionaries
                        .where_like(params[:search][:language], params[:search][:keyword])
    else
      @dictionaries = current_company.dictionaries
    end
  end

  private

    def languages
      return [] unless params[:languages]

      params[:languages].select { |l| l.in? Dictionary.allowed_languages.to_h.values }
    end
end
