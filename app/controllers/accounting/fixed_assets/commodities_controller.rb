class Accounting::FixedAssets::CommoditiesController < ApplicationController
  include ApplicationHelper

  before_action :find_commodity, only: [:show, :edit, :update]
  before_action :update_access, only: [:create, :edit, :update]

  helper_method :sort_column
  helper_method :params_search

  # GET /accounting
  def index
    @commodities = current_company.accounting_fixed_assets_commodities
    @commodities = @commodities.search_like params_search
    @commodities = @commodities.order("#{sort_column} #{sort_direction}")
  end

   # GET /accounting/1
  def show
    render 'edit'
  end

  # GET /accounting/new
  def new
    @commodity = current_company.accounting_fixed_assets_commodities.build
  end

  # PATCH/PUT /accounting/1
  def update
    if @commodity.update_by(commodity_params, current_user)
      redirect_to accounting_fixed_assets_commodities_path, notice: 'Hyödyke päivitettiin onnistuneesti.'
    else
      render action: 'edit'
    end
  end

  # GET /accounting/1/edit
  def edit
  end

  # POST /accounting
  def create
    @commodity = current_company.accounting_fixed_assets_commodities.build
    @commodity.attributes = commodity_params

    if @commodity.save_by current_user
      redirect_to accounting_fixed_assets_commodities_path, notice: 'Hyödyke luotiin onnistuneesti.'
    else
      render action: 'new'
    end
  end

  private

    # Only allow a trusted parameter "white list" through.
    def commodity_params
      params.require(:accounting_fixed_assets_commodity).permit(
        :nimitys,
        :selite,
        :summa,
        :hankintapvm,
        :kayttoonottopvm,
        :sumu_poistotyyppi,
        :sumu_poistoera,
        :evl_poistotyyppi,
        :evl_poistoera,
        :tilino
      )
    end

    def sort_column
      params.values.include?(params[:sort]) ? params[:sort] : "tunnus"
    end

    def params_search
      p = params.permit(
        :nimitys,
        :selite,
        :summa,
        :hankintapvm,
        :kayttoonottopvm,
        :sumu_poistotyyppi,
        :sumu_poistoera,
        :evl_poistotyyppi,
        :evl_poistoera,
        :tilino
      )
      p.reject { |_,v| v.empty? }
    end

    def find_commodity
      @commodity = current_company.accounting_fixed_assets_commodities.find(params[:id])
    end

    def update_access
      msg = "Sinulla ei ole päivitysoikeuksia."
      redirect_to accounting_fixed_assets_commodities_path, notice: msg unless update_access?
    end
end

