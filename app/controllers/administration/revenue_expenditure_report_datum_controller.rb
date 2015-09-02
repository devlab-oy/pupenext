class Administration::RevenueExpenditureReportDatumController < AdministrationController
  def index
    @data_set = Keyword::RevenueExpenditureReportData.all
  end

  def edit
  end

  def show
    render :edit
  end

  private

    def find_resource
      @data = Keyword::RevenueExpenditureReportData.find params[:id]
    end
end
