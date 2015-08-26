class Administration::CarriersController < AdministrationController
  def index
    @carriers = Carrier.search_like(search_params).order(order_params)
  end

  def show
    render :edit
  end

  def edit
  end

  def new
    @carrier = Carrier.new
    render :edit
  end

  def create
    @carrier = Carrier.new carrier_params

    if @carrier.save
      redirect_to carriers_path, notice: t("Rahdinkuljettaja luotiin onnistuneesti")
    else
      render :edit
    end
  end

  def update
    if @carrier.update carrier_params
      redirect_to carriers_path, notice: t("Rahdinkuljettaja päivitettiin onnistuneesti")
    else
      render :edit
    end
  end

  def destroy
    @carrier.destroy
    redirect_to carriers_path, notice: t("Rahdinkuljettaja poistettiin onnistuneesti")
  end

  private

    def carrier_params
      params.require(:carrier).permit(
        :koodi,
        :nimi,
        :neutraali,
        :pakkauksen_sarman_minimimitta
      )
    end

    def find_resource
      @carrier = Carrier.find params[:id]
    end

    def searchable_columns
      [
        :koodi,
        :nimi,
        :neutraali,
        :pakkauksen_sarman_minimimitta
      ]
    end

    def sortable_columns
      searchable_columns
    end
end
