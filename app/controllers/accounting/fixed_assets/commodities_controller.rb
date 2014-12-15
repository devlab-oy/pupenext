class Accounting::FixedAssets::CommoditiesController < ApplicationController
  include ApplicationHelper

  before_action :find_commodity, only: [:show, :edit, :update, :select_account]
  before_action :update_access, only: [:create, :edit, :update]

  helper_method :sort_column
  helper_method :params_search

  # GET /accounting/fixed_assets/commodities
  def index
    @commodities = current_company.accounting_fixed_assets_commodities
    @commodities = @commodities.search_like params_search
    @commodities = @commodities.order("#{sort_column} #{sort_direction}")
  end

   # GET /accounting/fixed_assets/commodities/1
  def show
    render 'edit'
  end

  # GET /accounting/fixed_assets/commodities/new
  def new
    @commodity = current_company.accounting_fixed_assets_commodities.build
  end

  # PATCH/PUT /accounting/fixed_assets/commodities/1
  def update
    @commodity.generate_rows = true
    if @commodity.update_by(commodity_params, current_user)
      redirect_to accounting_fixed_assets_commodities_path, notice: 'Hyödyke päivitettiin onnistuneesti.'
    else
      render action: 'edit'
    end
  end

  # GET /accounting/fixed_assets/commodities/1/edit
  def edit
    puts params
    @commodity.tilino = params[:selected_account]
  end

  # POST /accounting/fixed_assets/commodities
  def create
    @commodity = current_company.accounting_fixed_assets_commodities.build
    @commodity.attributes = commodity_params
    @commodity.generate_rows = true

    if @commodity.save_by current_user
      redirect_to accounting_fixed_assets_commodities_path, notice: 'Hyödyke luotiin onnistuneesti.'
    else
      render action: 'new'
    end
  end

  # GET /accounting/fixed_assets/commodities/1/select_account
  def select_account
    render 'select_account'
  end

   # GET /accounting/fixed_assets/commodities/1/select_purchase_order
  def select_purchase_order
    render 'select_purchase_order'
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
        :tilino,
        :tila,
        :selected_account
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
        :tilino,
        :tila,
        :selected_account
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

