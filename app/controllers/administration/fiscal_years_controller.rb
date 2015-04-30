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
  end

  def edit
  end

  def create
    @fiscal_year = FiscalYear.new(fiscal_year_params)

    if @fiscal_year.save_by(current_user)
      redirect_to @fiscal_year, notice: 'Tilikausi luotiin onnistuneesti.'
    else
      render :edit
    end
  end

  def update
    if @fiscal_year.update_by(fiscal_year_params, current_user)
      redirect_to @fiscal_year, notice: 'Tilikausi päivitettiin onnistuneesti.'
    else
      render :edit
    end
  end

  private

    def find_resource
      @fiscal_year = FiscalYear.find(params[:id])
    end

    def fiscal_year_params
      params.require(:fiscal_year).permit(
        :tilikausi_alku,
        :tilikausi_loppu
      )
    end

    def searchable_columns
      [
        :tilikausi_alku,
        :tilikausi_loppu
      ]
    end

    def sortable_columns
      searchable_columns
    end
end
