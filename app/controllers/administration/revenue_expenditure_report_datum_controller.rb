class Administration::RevenueExpenditureReportDatumController < AdministrationController
  def index
    @data_set = Keyword::RevenueExpenditureReportData.all
  end

  def edit
  end

  def show
    render :edit
  end

  # def self.delete_keyword(params)

  #   if Keyword::RevenueExpenditureReportData.delete params[:id]
  #     return true
  #   else
  #     return false
  #   end
  # end

  # def self.update_keyword(params)

  #   update_params = {
  #     selite: params[:week],
  #     selitetark: params[:name],
  #     selitetark_2: params[:sum],
  #   }

  #   if Keyword::RevenueExpenditureReportData.update params[:id], update_params
  #     return true
  #   else
  #     return false
  #   end
  # end

  # def self.save_keyword(params)

  #   save_params = {
  #     selite: params[:week],
  #     selitetark: params[:name],
  #     selitetark_2: params[:sum],
  #   }

  #   keyword = Keyword::RevenueExpenditureReportData.new save_params

  #   if keyword.save
  #     return true
  #   else
  #     return false
  #   end
  # end
end
