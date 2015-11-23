class Administration::OnlineStoresController < AdministrationController
  def index
    @online_stores = OnlineStore.all
  end

  def show
    render :edit
  end

  def new
    @online_store = OnlineStore.new
  end

  def edit; end

  def create
    @online_store = OnlineStore.new(online_store_params)

    if @online_store.save
      redirect_to online_stores_url, notice: t('.success')
    else
      render :new
    end
  end

  def update
    if @online_store.update(online_store_params)
      redirect_to online_stores_url, notice: t('.success')
    else
      render :edit
    end
  end

  def destroy
    @online_store.destroy

    redirect_to online_stores_url, notice: t('.success')
  end

  private

    def find_resource
      @online_store = OnlineStore.find(params[:id])
    end

    def online_store_params
      params.require(:online_store).permit(:name)
    end
end
