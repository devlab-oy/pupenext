class DataImportController < ApplicationController
  before_action :check_for_file, except: [ :index ]

  def index
  end

  def product_keywords
    @spreadsheet = Import::ProductKeyword.new @uploaded_file

    if @spreadsheet.import
      flash[:notice] = 'Data imported!'
      redirect_to data_import_path
    else
      render :results
    end
  end

  private

    def check_for_file
      @uploaded_file = params[:file]

      if @uploaded_file.blank?
        flash[:error] = 'no file found!'
        redirect_to data_import_path
      end
    end
end
