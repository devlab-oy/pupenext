class Administration::PackingAreasController < AdministrationController
  def index
    @packing_areas = PackingArea.search_like(search_params).order(order_params)
  end

  def show
    render :edit
  end

  def edit
  end

  def new
    @packing_area = PackingArea.new
  end

  def create
    @packing_area = PackingArea.new(packing_area_params)

    if @packing_area.save_by current_user
      redirect_to packing_areas_path, notice: t('.create_success')
    else
      render :edit
    end
  end

  def update
    if @packing_area.update_by(packing_area_params, current_user)
      redirect_to packing_areas_path, notice: t('.update_success')
    else
      render :edit
    end
  end

  def destroy
    PackingArea.destroy(params[:id])
    redirect_to packing_areas_path, notice: t('.destroy_success')
  end

  private

    def find_resource
      @packing_area = PackingArea.find(params[:id])
    end

    def searchable_columns
      [
        :nimi,
        :lokero,
        :prio,
        :pakkaamon_prio,
        :varasto
      ]
    end

    def sortable_columns
      searchable_columns
    end

    def packing_area_params
      params.require(:packing_area).permit(
        :nimi,
        :lokero,
        :prio,
        :pakkaamon_prio,
        :varasto,
        :printteri0,
        :printteri1,
        :printteri2,
        :printteri3,
        :printteri4,
        :printteri6,
        :printteri7
      )
    end
end
