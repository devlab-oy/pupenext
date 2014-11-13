class SumLevelsController < ApplicationController
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

  before_action :find_sum_level, only: [:show, :edit, :update, :destroy]
  before_action :update_access, only: [:new, :create, :update, :destroy]

  sortable_columns *COLUMNS
  default_sort_column :tunnus

  def index
    @sum_levels = current_company.sum_levels
    @sum_levels = @sum_levels.search_like filter_search_params
    @sum_levels = @sum_levels.order("#{sort_column} #{sort_direction}")
  end

  def new
    #TODO wait for rails to fix their .build
    #current_company.sum_levels.build doesnt work
    #https://github.com/rails/rails/issues/17121
    default_klass = SumLevel.default_child_instance
    @sum_level = default_klass.new({ company: current_company })
  end

  def show
    render :edit
  end

  def create
    default_klass = SumLevel.child_class sum_level_params[:tyyppi]
    @sum_level = default_klass.new({ company: current_company })
    @sum_level.attributes = sum_level_params

    if @sum_level.save_by current_user
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
    flash.notice = 'Taso poistettiin onnistuneesti'
    redirect_to sum_levels_path
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

    def find_sum_level
      @sum_level = current_company.sum_levels.find(params[:id])
    end

    def update_access
      msg = "Sinulla ei ole päivitysoikeuksia"
      redirect_to sum_levels_path, notice: msg unless update_access?
    end
end
