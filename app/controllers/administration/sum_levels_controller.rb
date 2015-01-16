class Administration::SumLevelsController < AdministrationController
  def index
    @sum_levels = current_company
      .sum_levels
      .search_like(search_params)
      .order(order_params)
  end

  def new
    @sum_level = current_company.sum_level_internals.build
  end

  def show
    render :edit
  end

  def create
    @sum_level = current_company.sum_levels.build(sum_level_params)

    if params[:commit] && @sum_level.save_by(current_user)
      redirect_to sum_levels_path, notice: 'Taso luotiin onnistuneesti'
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
      redirect_to sum_levels_path, notice: 'Taso päivitettiin onnistuneesti'
    elsif @sum_level.update_by(sum_level_params, current_user)
      render :edit
    else
      render :edit
    end
  end

  def destroy
    @sum_level.destroy
    redirect_to sum_levels_path, notice: 'Taso poistettiin onnistuneesti'
  end

  private

    def find_resource
      @sum_level = current_company.sum_levels.find params[:id]
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
