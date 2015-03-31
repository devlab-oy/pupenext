class Administration::PackingAreasController < AdministrationController

  before_action :find_packing_area, only: [:show, :edit, :update]
  before_action :find_printers, only: [:new, :show, :create, :edit, :update]
  before_action :find_storages, only: [:new, :show, :create, :edit, :update]

  def index
    @packing_areas = current_user.company.packing_areas
  end

  def show
     render 'edit'
  end

  def edit
  end

  def new
    @packing_area = current_user.company.packing_areas.build
    @packing_area.varasto = nil
    @packing_area.prio = nil
    @packing_area.pakkaamon_prio = nil
  end

  def create
    @packing_area = current_user.company.packing_areas.build
    @packing_area.attributes = packing_area_params
    @packing_area.muuttaja = current_user.kuka
    @packing_area.laatija = current_user.kuka

    if @packing_area.save
      redirect_to packing_areas_path, notice: 'Packing area was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    @packing_area.attributes = packing_area_params
    @packing_area.muuttaja = current_user.kuka

    if @packing_area.save
      redirect_to packing_areas_path, notice: 'Packing area was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    PackingArea.destroy(params[:id])
    redirect_to packing_areas_path, notice: 'Packing area was successfully deleted.'
  end

  private

    def find_packing_area
      @packing_area = current_user.company.packing_areas.find(params[:id])
    end

    def find_printers
      @printers = Printers.all
    end

    def find_storages
      @storages = Storages.all
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
