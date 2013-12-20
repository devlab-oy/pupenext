class CurrenciesController < ApplicationController

  before_action :find_currency, only: [:show, :edit, :update, :destroy]

  # GET /currencies
  def index
    @currencies = Currency.all
  end

  # GET /currencies/1
  def show
    render 'edit'
  end

  # GET /currencies/new
  def new
    @currency = Currency.new
  end

  # POST /currencies
  def create
    @currency = Currency.new
    @currency.attributes = currency_params

    if @currency.save
      redirect_to @currency, notice: 'Currency was successfully created.'
    else
      render action: 'new'
    end
  end

  # GET /currencies/1/edit
  def edit

  end

  # PATCH/PUT /currencies/1
  def update
    if @currency.update(currency_params)
      redirect_to currencies_path, notice: 'Currency was successfully updated.'
    else
      render action: 'edit'
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def currency_params
      params[:currency].permit(
        :tunnus,
        :nimi,
        :kurssi,
      )
    end

    def find_currency
      @currency = Currency.find(params[:id])
    end
end
