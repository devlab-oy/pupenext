class FixedAssets::CommoditiesController < AdministrationController
  # GET /fixed_assets/commodities
  def index
    @commodities = current_company.commodities
      .search_like(search_params)
      .order(order_params)
  end

   # GET /fixed_assets/commodities/1
  def show
    render 'edit'
  end

  # GET /fixed_assets/commodities/new
  def new
    @commodity = current_company.commodities.build
  end

  # PATCH/PUT /fixed_assets/commodities/1
  def update
    @commodity.generate_rows = true

    if @commodity.update_by(commodity_params, current_user)
      redirect_to accounting_fixed_assets_commodities_path, notice: 'Hyödyke päivitettiin onnistuneesti.'
    else
      render action: 'edit'
    end
  end

  # GET /fixed_assets/commodities/1/edit
  def edit
    @commodity.link_cost_row params[:selected_accounting_row] unless params[:selected_accounting_row].nil?
    @commodity.tilino = params[:selected_account] unless params[:selected_account].nil?
  end

  # POST /fixed_assets/commodities
  def create
    @commodity = current_company.commodities.build
    @commodity.attributes = commodity_params

    if @commodity.save_by current_user
      redirect_to accounting_fixed_assets_commodities_path, notice: 'Hyödyke luotiin onnistuneesti.'
    else
      render action: 'new'
    end
  end

  # GET /fixed_assets/commodities/1/select_purchase_order
  def select_purchase_order
    @purchase_orders = current_company.purchase_orders.limit(50)
    @purchase_orders = @purchase_orders.search_like params_search
    @purchase_orders = @purchase_orders.order("#{sort_column} #{sort_direction}")
  end

  # GET /fixed_assets/commodities/1/select_voucher
  def select_voucher
    @vouchers = current_company.accounting_vouchers.limit(50)
    @vouchers = @vouchers.search_like params_search
    @vouchers = @vouchers.order("#{sort_column} #{sort_direction}")
  end

  def fiscal_year_run
    @commodities = current_company.commodities.activated
    @commodities.each do |com|
      com.generate_rows = true
      com.save
    end
    @commodities.reload
    @commodities.each do |com|
      #All bookkeepping rows locked
      com.lock_all_rows
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

    def searchable_columns
      [
        :selite,
      ]
    end

    def sortable_columns
      searchable_columns
    end

    def find_resource
      @commodity = current_company.commodities.find(params[:id])
    end
end

