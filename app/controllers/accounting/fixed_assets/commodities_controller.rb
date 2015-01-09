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
    @commodity.link_cost_row params[:selected_accounting_row] unless params[:selected_accounting_row].nil?
    @commodity.tilino = params[:selected_account] unless params[:selected_account].nil?
  end

  # POST /accounting/fixed_assets/commodities
  def create
    @commodity = current_company.accounting_fixed_assets_commodities.build
    @commodity.attributes = commodity_params

    if @commodity.save_by current_user
      redirect_to accounting_fixed_assets_commodities_path, notice: 'Hyödyke luotiin onnistuneesti.'
    else
      render action: 'new'
    end
  end

  # GET /accounting/fixed_assets/commodities/1/select_account
  def select_account
    @accounts = current_company.accounting_accounts.limit(50)
    render 'select_account'
  end

  # GET /accounting/fixed_assets/commodities/1/select_purchase_order
  def select_purchase_order
    @purchase_orders = current_company.purchase_orders.limit(50)
    @purchase_orders = @purchase_orders.search_like params_search
    @purchase_orders = @purchase_orders.order("#{sort_column} #{sort_direction}")
  end

  # GET /accounting/fixed_assets/commodities/1/select_voucher
  def select_voucher
    @vouchers = current_company.accounting_vouchers.limit(50)
    @vouchers = @vouchers.search_like params_search
    @vouchers = @vouchers.order("#{sort_column} #{sort_direction}")
  end

  def fiscal_year_run
    @commodities = current_company.accounting_fixed_assets_commodities.activated
    @commodities.each do |com|
      com.generate_rows = true
      com.save
    end
    @commodities.reload
    @commodities.each do |com|
      #External bookkeepping rows locked
      com.active.rows.each do |row|
        row.lukko = 'x'
      end
      #Internal bookkeepping rows locked
      com.accounting_voucher.rows.each do |crow|
        crow.lukko = 'x'
      end

      com.save
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
        :tilino,
        :tila,
        :kustp,
        :kohde,
        :projekti
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
        :viite,
        :nimi,
        :ytunnus,
        :viesti
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

