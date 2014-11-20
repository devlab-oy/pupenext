class Administration::CurrenciesController < AdministrationController
  COLUMNS = [
    :nimi,
    :kurssi,
  ]

  sortable_columns *COLUMNS
  default_sort_column :jarjestys

  # GET /currencies
  def index
    @currencies = current_company.currency
    @currencies = @currencies.search_like filter_search_params
    @currencies = @currencies.order("#{sort_column} #{sort_direction}")
  end

  # GET /currencies/1
  def show
    render 'edit'
  end

  # GET /currencies/new
  def new
    @currency = current_company.currency.build
  end

  # POST /currencies
  def create
    @currency = current_company.currency.build
    @currency.attributes = currency_params

    if @currency.save_by current_user
      redirect_to currencies_path, notice: 'Valuutta luotiin onnistuneesti.'
    else
      render action: 'new'
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
      render action: 'edit'
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def currency_params
      params.require(:currency).permit(
        :nimi,
        :jarjestys,
        :kurssi,
        :intrastat_kurssi,
      )
    end

    def searchable_columns
      COLUMNS
    end

    def find_resource
      @currency = current_company.currency.find(params[:id])
    end

  def no_update_access_path
    currencies_path
  end
end
