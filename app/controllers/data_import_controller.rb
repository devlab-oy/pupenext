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

  def product_information
    @spreadsheet = Import::ProductInformation.new(
      company_id: current_company.id,
      user_id: current_user.id,
      filename: @uploaded_file,
      language: product_information_params[:language],
      type: product_information_params[:type],
    ).import

    render :results
  end

  private

    def check_for_file
      @uploaded_file = data_import_params[:file]

      if @uploaded_file.blank?
        flash[:error] = 'no file found!'
        redirect_to data_import_path
      end
    end

    def data_import_params
      params.require(:data_import).permit(:file)
    end

    def product_information_params
      params.require(:data_import).permit(
        :language,
        :type,
      )
    end
end
