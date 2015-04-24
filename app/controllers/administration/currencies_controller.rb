class Administration::CurrenciesController < AdministrationController
  # GET /currencies
  def index
    @currencies = current_company
      .currencies
      .search_like(search_params)
      .order(order_params)
  end

  # GET /currencies/1
  def show
    render :edit
  end

  # GET /currencies/new
  def new
    @currency = current_company.currencies.build
  end

  # POST /currencies
  def create
    @currency = current_company.currencies.build
    @currency.attributes = currency_params

    if @currency.save_by current_user
      redirect_to currencies_path, notice: 'Valuutta luotiin onnistuneesti.'
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
      redirect_to currencies_path, notice: 'Valuutta päivitettiin onnistuneesti.'
    else
      render :edit
    end
  end

  private

    def find_resource
      @currency = current_company.currencies.find(params[:id])
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
