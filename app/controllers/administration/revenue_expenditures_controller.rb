class Administration::RevenueExpendituresController < AdministrationController
  def index
    data_set = Keyword::RevenueExpenditure.all.search_like(search_params)

    @revenue_expenditures = data_set.all.order(:selite, :selitetark, :selitetark_2)
  end

  def new
    current_week = Week.new(Time.zone.today).compact

    @revenue_expenditure = Keyword::RevenueExpenditure.new selite: current_week

    render :edit
  end

  def edit
  end

  def show
    render :edit
  end

  def create
    @revenue_expenditure = Keyword::RevenueExpenditure.new revenue_expenditures_params

    if @revenue_expenditure.save
      redirect_to revenue_expenditures_path
    else
      render :edit
    end
  end

  def update
    if @revenue_expenditure.update revenue_expenditures_params
      redirect_to revenue_expenditures_path
    else
      render :edit
    end
  end

  def destroy
    @revenue_expenditure.destroy
    redirect_to revenue_expenditures_path
  end

  private

    def find_resource
      @revenue_expenditure = Keyword::RevenueExpenditure.find params[:id]
    end

    def revenue_expenditures_params
      params.require(:revenue_expenditure).permit(
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
