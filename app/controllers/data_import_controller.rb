class DataImportController < ApplicationController
  before_action :check_for_file, except: [ :index ]

  def index
  end

  def product_keywords
    @spreadsheet = Import::ProductKeyword.new(
      company_id: current_company.id,
      user_id: current_user.id,
      filename: @uploaded_file,
    ).import

    render :results
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
