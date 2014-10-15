class CurrenciesController < ApplicationController
  include ApplicationHelper

  before_action :find_currency, only: [:show, :edit, :update, :destroy]

  helper_method :sort_column
  helper_method :params_search

  # GET /currencies
  def index
    @currencies = current_company.currency.order("#{sort_column} #{sort_direction}")
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
    @currency.muuttaja = current_user.kuka
    @currency.laatija = current_user.kuka

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
    @currency.muuttaja = current_user.kuka

    if @currency.update(currency_params)
      redirect_to currencies_path, notice: 'Currency was successfully updated.'
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
      )
    end

    def params_search
      params.permit(
        :nimi,
        :kurssi,
        :sort,
        :direction
      )
    end

    def find_currency
      @currency = current_company.currency.find(params[:id])
    end

    def sort_column
      params_search.has_value?(params[:sort]) ? params[:sort] : "jarjestys"
    end
end
