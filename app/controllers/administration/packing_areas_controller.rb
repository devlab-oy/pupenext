class Administration::PackingAreasController < AdministrationController
  before_action :find_printers, only: [:new, :show, :create, :edit, :update]
  before_action :find_storages, only: [:new, :show, :create, :edit, :update]
  helper_method :get_storage

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
    @packing_area.varasto = nil
    @packing_area.prio = nil
    @packing_area.pakkaamon_prio = nil
  end

  def create
    @packing_area = PackingArea.new(packing_area_params)

    if @packing_area.save_by current_user
      redirect_to packing_areas_path, notice: t("Pakkaamo luotiin onnistuneesti")
    else
      render action: 'new'
    end
  end

  def update
    if @packing_area.update_by(packing_area_params, current_user)
      redirect_to packing_areas_path, notice: t("Pakkaamo päivitettiin onnistuneesti")
    else
      render action: 'edit'
    end
  end

  def destroy
    PackingArea.destroy(params[:id])
    redirect_to packing_areas_path, notice: t("Pakkaamo poistettiin onnistuneesti")
  end

  private

    def get_storage(storage_id)
      Storage.find_by_tunnus(storage_id).nimitys
    end

    def find_resource
      @packing_area = PackingArea.find(params[:id])
    end

    def find_printers
      @printers = Printer.where.not(komento: "EDI").order(:kirjoitin)
    end

    def find_storages
      @storages = Storage.where.not(tyyppi: "P").order(:nimitys)
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
