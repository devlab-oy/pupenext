class Administration::FiscalYearsController < AdministrationController
  def index
    @fiscal_years = FiscalYear
      .search_like(search_params)
      .order(order_params)
  end

  def show
    render :edit
  end

  def new
    @fiscal_year = FiscalYear.new
    render :edit
  end

  def edit
  end

  def create
    @fiscal_year = FiscalYear.new fiscal_year_params

    if @fiscal_year.save
      redirect_to fiscal_years_path, notice: t('.create_success')
    else
      render :edit
    end
  end

  def update
    if @fiscal_year.update fiscal_year_params
      redirect_to fiscal_years_path, notice: t('.update_success')
    else
      render :edit
    end
  end

  private

    def find_resource
      @fiscal_year = FiscalYear.find params[:id]
    end

    def fiscal_year_params
      params.require(:fiscal_year).permit(
        tilikausi_alku:  [:day, :month, :year],
        tilikausi_loppu: [:day, :month, :year],
      )
    end

    def searchable_columns
      []
    end

    def sortable_columns
      [
        :tilikausi_alku,
        :tilikausi_loppu
      ]
    end
end
