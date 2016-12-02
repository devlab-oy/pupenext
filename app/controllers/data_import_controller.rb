class DataImportController < ApplicationController
  before_action :check_for_file, except: [:index, :destroy_customer_sales]

  def index
  end

  def customer_sales
    @spreadsheet = Import::CustomerSales.new(customer_sales_attributes).import
    @text = SalesOrder::Detail.model_name.human

    render :results
  end

  def destroy_customer_sales
    SalesOrder::Detail.where(tapvm: customer_sales_date).destroy_all
    SalesOrder::DetailRow.where(laskutettuaika: customer_sales_date).destroy_all

    flash[:notice] = t('.destroy_success')
    render :index
  end

  def product_keywords
    @spreadsheet = Import::ProductKeyword.new(
      company_id: current_company.id,
      user_id: current_user.id,
      filename: @uploaded_file,
    ).import

    @text = Product::Keyword.model_name.human

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

    @text = Product::Keyword.model_name.human

    render :results
  end

  private

    def check_for_file
      @uploaded_file = data_import_params[:file]

      if @uploaded_file.blank?
        flash[:error] = 'no file found!'
        redirect_to data_import_path
      elsif !allowed_extension?(@uploaded_file.original_filename)
        flash[:error] = 'invalid file type!'
        redirect_to data_import_path
      end
    end

    def customer_sales_params
      params.require(:data_import).permit(
        'month_year(1i)',
        'month_year(2i)',
        :product,
        :customer_number,
      )
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

    def allowed_extension?(filename)
      %w(.csv .xlsx .xls .ods).include? File.extname(filename)
    end

    def customer_sales_attributes
      {
        company_id: current_company.id,
        user_id: current_user.id,
        filename: @uploaded_file,
        month: customer_sales_params['month_year(2i)'],
        year: customer_sales_params['month_year(1i)'],
        product: customer_sales_params[:product],
        customer_number: customer_sales_params[:customer_number],
      }
    end

    def customer_sales_date
      month = customer_sales_params['month_year(2i)']
      year  = customer_sales_params['month_year(1i)']

      Date.new(year.to_i, month.to_i, 1).end_of_month
    end
end
