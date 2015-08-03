class Administration::CurrenciesController < AdministrationController
  # GET /currencies
  def index
    @currencies = Currency
      .search_like(search_params)
      .order(order_params)
  end

  # GET /currencies/1
  def show
    render :edit
  end

  # GET /currencies/new
  def new
    @currency = Currency.new
  end

  # POST /currencies
  def create
    @currency = Currency.new
    @currency.attributes = currency_params

    if @currency.save_by current_user
      redirect_to currencies_path, notice: t('.create_success')
    else
      render :new
    end
  end

  # GET /currencies/1/edit
  def edit
  end

  # PATCH/PUT /currencies/1
  def update
    if @currency.update_by(currency_params, current_user)
      redirect_to currencies_path, notice: t('.update_success')
    else
      render :edit
    end
  end

  private

    def find_resource
      @currency = Currency.find(params[:id])
    end

    def currency_params
      params.require(:currency).permit(
        :nimi,
        :jarjestys,
        :kurssi,
        :intrastat_kurssi,
      )
    end

    def searchable_columns
      [
        :nimi,
        :kurssi,
      ]
    end

    def sortable_columns
      [
        :jarjestys,
        :nimi,
        :kurssi,
      ]
    end
end
