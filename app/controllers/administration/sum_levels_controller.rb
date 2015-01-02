class Administration::SumLevelsController < AdministrationController
  COLUMNS = [
    :taso,
    :tyyppi,
    :nimi,
    :summattava_taso,
    :kumulatiivinen,
    :oletusarvo,
    :kerroin,
    :jakaja,
  ]

  sortable_columns *COLUMNS
  default_sort_column :tunnus

  def index
    @sum_levels = current_company.sum_levels
    @sum_levels = @sum_levels.search_like filter_search_params
    @sum_levels = @sum_levels.order("#{sort_column} #{sort_direction}")
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
    if @sum_level.update_by sum_level_params, current_user
      redirect_to sum_levels_path, notice: 'Taso päivitettiin onnistuneesti'
    else
      render :edit
    end
  end

  def destroy
    @sum_level.destroy
    redirect_to sum_levels_path, notice: 'Taso poistettiin onnistuneesti'
  end

  private

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
      COLUMNS
    end

    def find_resource
      @sum_level = current_company.sum_levels.find params[:id]
    end

    def no_update_access_path
      sum_levels_path
    end
end
