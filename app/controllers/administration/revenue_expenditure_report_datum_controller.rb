class Administration::RevenueExpenditureReportDatumController < AdministrationController
  def index
    @data_set = Keyword::RevenueExpenditureReportData.all
  end

  def edit
  end

  def show
    render :edit
  end

  def update
    if @data.update revenue_expenditure_report_data_params
      redirect_to revenue_expenditure_report_datum_index_path
    else
      render :edit
    end
  end

  private

    def find_resource
      @data = Keyword::RevenueExpenditureReportData.find params[:id]
    end

    def revenue_expenditure_report_data_params
      params.require(:data).permit(
        :selite,
        :selitetark,
        :selitetark_2,
      )
    end
end
