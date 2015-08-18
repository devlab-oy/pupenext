class Administration::AccountsController < AdministrationController
  def index
    @accounts = Account
      .includes(:internal, :external, :vat)
      .search_like(search_params)
      .order(order_params)
  end

  def new
    @account = Account.new
    render :edit
  end

  def show
    render :edit
  end

  def create
    @account = Account.new account_params

    if @account.save
      redirect_to accounts_path, notice: t('.create_success')
    else
      render :edit
    end
  end

  def edit
  end

  def update
    if @account.update account_params
      redirect_to accounts_path, notice: t('.update_success')
    else
      render :edit
    end
  end

  def destroy
    @account.destroy
    redirect_to accounts_path, notice: t('.destroy_success')
  end

  private

    def find_resource
      @account = Account.find params[:id]
    end

    def account_params
      params.require(:account).permit(
        :tilino,
        :sisainen_taso,
        :ulkoinen_taso,
        :alv_taso,
        :tulosseuranta_taso,
        :evl_taso,
        :nimi,
        :kustp,
        :kohde,
        :projekti,
        :toimijaliitos,
        :tiliointi_tarkistus,
        :manuaali_esto,
        :oletus_alv
      )
    end

    def searchable_columns
      [
        :tilino,
        :nimi,
        :sisainen_taso,
        :ulkoinen_taso,
        :alv_taso
      ]
    end

    def sortable_columns
      searchable_columns
    end
end
