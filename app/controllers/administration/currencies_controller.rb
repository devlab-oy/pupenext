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
  end

  def create
    @currency = Currency.new(currency_params)

    if @currency.save_by current_user
      redirect_to currencies_path, notice: 'Valuutta luotiin onnistuneesti.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @currency.update_by(currency_params, current_user)
      redirect_to currencies_path, notice: 'Valuutta päivitettiin onnistuneesti.'
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
