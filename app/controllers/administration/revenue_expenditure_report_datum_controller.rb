class Administration::RevenueExpenditureReportDatumController < AdministrationController
  def index
    data_set = Keyword::RevenueExpenditureReportData.all.search_like(search_params)

    @data_set = data_set.all.order(:selite, :selitetark, :selitetark_2)
  end

  def new
    @data = Keyword::RevenueExpenditureReportData.new
    render :edit
  end

  def edit
  end

  def show
    render :edit
  end

  def create
    @data = Keyword::RevenueExpenditureReportData.new revenue_expenditure_report_data_params

    if @data.save
      redirect_to revenue_expenditure_report_datum_index_path
    else
      render :edit
    end
  end

  def update
    if @data.update revenue_expenditure_report_data_params
      redirect_to revenue_expenditure_report_datum_index_path
    else
      render :edit
    end
  end

  def destroy
    @data.destroy
    redirect_to revenue_expenditure_report_datum_index_path
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

    def searchable_columns
      [
        :selite,
        :selitetark,
        :selitetark_2,
      ]
    end
end
