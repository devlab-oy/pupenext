class FixedAssets::CommoditiesController < AdministrationController

  before_action :find_resource, only: [:vouchers, :link_voucher, :purchase_orders, :link_purchase_order, :show, :edit, :update]

  # GET /commodities
  def index
    @commodities = current_company.commodities
      .search_like(search_params)
      .order(order_params)
  end

   # GET /commodities/1
  def show
    render :edit
  end

  # GET /commodities/new
  def new
    @commodity = current_company.commodities.build
  end

  # PATCH /commodities/1
  def update
    if @commodity.update_by(commodity_params, current_user)
      redirect_to edit_commodity_path(@commodity), notice: 'Hyödyke päivitettiin onnistuneesti.'
    else
      render :edit
    end
  end

  # GET /commodities/1/edit
  def edit
  end

  # POST /commodities
  def create
    @commodity = current_company.commodities.build(commodity_create_params)

    if @commodity.save_by current_user
      redirect_to edit_commodity_path(@commodity), notice: 'Hyödyke luotiin onnistuneesti.'
    else
      render :new
    end
  end

  # GET /commodities/1/purchase_orders
  def purchase_orders
    @purchase_orders = @commodity.linkable_invoices
  end

  # POST /commodities/1/purchase_orders
  def link_purchase_order
    render nothing: true
  end

  # GET /commodities/1/vouchers
  def vouchers
    #@vouchers = @commodity.linkable_vouchers
    @vouchers = current_company.vouchers.limit(50)
  end

  # POST /commodities/1/vouchers
  def link_voucher
    render nothing: true
  end

  private

    # Allow only these params for update
    def commodity_params
      params.require(:fixed_assets_commodity).permit(
        :name,
        :description,
        :amount,
        :purchased_at,
        :activated_at,
        :planned_depreciation_type,
        :planned_depreciation_amount,
        :btl_depreciation_type,
        :btl_depreciation_amount,
        :status,
        :cost_centre,
        :target,
        :project
      )
    end

    # Allow only these params for create
    def commodity_create_params
      params.require(:fixed_assets_commodity).permit(
        :name,
        :description
      )
    end

    def searchable_columns
      [
        :name,
        :description
      ]
    end

    def sortable_columns
      searchable_columns
    end

    def find_resource
      @commodity = current_company.commodities.find(params[:commodity_id] || params[:id])
    end
end
