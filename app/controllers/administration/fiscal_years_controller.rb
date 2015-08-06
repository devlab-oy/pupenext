class Administration::FiscalYearsController < AdministrationController
  # GET /fiscal_years
  def index
    @fiscal_years = FiscalYear
      .search_like(search_params)
      .order(order_params)
  end

  # GET /fiscal_years/1
  def show
    render :edit
  end

  # GET /fiscal_years/new
  def new
    @fiscal_year = FiscalYear.new
    render :edit
  end

  # GET /fiscal_years/1/edit
  def edit
  end

  # POST /fiscal_years
  def create
    @fiscal_year = FiscalYear.new(fiscal_year_params)

    if @fiscal_year.save_by(current_user)
      redirect_to fiscal_years_path, notice: t('.create_success')
    else
      render :edit
    end
  end

  # PATCH/PUT /fiscal_years/1
  def update
    if @fiscal_year.update_by(fiscal_year_params, current_user)
      redirect_to fiscal_years_path, notice: t('.update_success')
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
        tilikausi_alku:  [:day, :month, :year],
        tilikausi_loppu: [:day, :month, :year]
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
