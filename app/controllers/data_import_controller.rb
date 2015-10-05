class DataImportController < ApplicationController
  before_action :check_for_file, except: [ :index ]

  def index
  end

  def product_keywords
    if @uploaded_file
      flash[:notice] = 'Data imported!'
      redirect_to data_import_path
    else
      render :results
    end
  end

  private

    def check_for_file
      @uploaded_file = params[:file]

      unless @uploaded_file
        flash[:error] = 'no file found!'
        redirect_to data_import_path
      end
    end
end
