class Administration::SumLevelsController < AdministrationController
  def index
    @sum_levels = SumLevel.search_like(search_params).order(order_params)
  end

  def new
    @sum_level = SumLevel::Internal.new
    render :edit
  end

  def show
    render :edit
  end

  def create
    @sum_level = SumLevel.new(sum_level_params)

    if params[:commit] && @sum_level.save_by(current_user)
      redirect_to sum_levels_path, notice: t('.create_success')
    else
      render :edit
    end
  end

  def edit
  end

  def update
    # Redirect to sum_levels_path only if commit is present in params (submit button or enter
    # pressed). Otherwise submits triggered i.e. from select updates would also result in
    # redirection.
    if params[:commit] && @sum_level.update_by(sum_level_params, current_user)
      redirect_to sum_levels_path, notice: t('.update_success')
    else
      @sum_level.assign_attributes(sum_level_params)
      render :edit
    end
  end

  def destroy
    @sum_level.destroy
    redirect_to sum_levels_path, notice: t('.destroy_success')
  end

  private

    def find_resource
      @sum_level = SumLevel.find params[:id]
    end

    def sum_level_params
      params.require(:sum_level).permit(
        :tyyppi,
        :summattava_taso,
        :taso,
        :nimi,
        :oletusarvo,
        :jakaja,
        :kumulatiivinen,
        :kayttotarkoitus,
        :kerroin,
        :poisto_vastatili,
        :poistoero_tili,
        :poistoero_vastatili,
        :planned_depreciation_type,
        :planned_depreciation_amount,
        :btl_depreciation_type,
        :btl_depreciation_amount,
      )
    end

    def searchable_columns
      [
        :taso,
        :tyyppi,
        :nimi,
        :summattava_taso,
        :kumulatiivinen,
        :oletusarvo,
        :kerroin,
        :jakaja
      ]
    end

    def sortable_columns
      searchable_columns
    end
end
