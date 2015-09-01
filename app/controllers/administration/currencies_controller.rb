class Administration::CurrenciesController < AdministrationController
  def index
    @currencies = Currency
      .search_like(search_params)
      .order(order_params)
  end

  def show
    render :edit
  end

  def new
    @currency = Currency.new
    render :edit
  end

  def create
    @currency = Currency.new currency_params

    if @currency.save
      redirect_to currencies_path, notice: t('.create_success')
    else
      render :edit
    end
  end

  def edit
  end

  def update
    if @currency.update currency_params
      redirect_to currencies_path, notice: t('.update_success')
    else
      render :edit
    end
  end

  private

    def find_resource
      @currency = Currency.find params[:id]
    end

    def currency_params
      resource_parameters model: :currency, parameters: [
        :nimi,
        :jarjestys,
        :kurssi,
        :intrastat_kurssi,
      ]
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
