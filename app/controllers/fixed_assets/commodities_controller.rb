class FixedAssets::CommoditiesController < AdministrationController
  before_action :find_resource, except: [:index, :new, :create]
  before_action :find_voucher_row, only: [:link_purchase_order, :link_voucher, :unlink_procurement]
  before_action :unlinking_allowed_check, only: [:unlink_procurement]
  before_action :linkable_purchase_orders, only: [:purchase_orders, :link_purchase_order]
  before_action :linkable_vouchers, only: [:vouchers, :link_voucher]

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
  end

  # POST /commodities/1/link_order
  def link_purchase_order
    if link_voucher_row
      redirect_to commodity_purchase_orders_path, notice: 'Tiliöintirivi liitettiin onnistuneesti.'
    else
      render :purchase_orders
    end
  end

  # GET /commodities/1/vouchers
  def vouchers
  end

  # POST /commodities/1/link_voucher
  def link_voucher
    if link_voucher_row
      redirect_to commodity_vouchers_path, notice: 'Tiliöintirivi liitettiin onnistuneesti.'
    else
      render :vouchers
    end
  end

  # POST /commodities/1/unlink
  def unlink_procurement
    if unlink_voucher_row
      redirect_to edit_commodity_path(@commodity), notice: 'Tiliöintivi poistettu hyödykkeeltä.'
    else
      render :edit
    end
  end

  # POST /commodities/1/activate
  def activate
    @commodity.status = 'A'

    if @commodity.save_by current_user
      redirect_to edit_commodity_path(@commodity), notice: 'Hyödyke aktivoitiin onnistuneesti.'
    else
      @commodity.status = ''
      render :edit
    end
  end

  def generate_rows
    options = {
      commodity_id: @commodity.id,
      fiscal_id: params[:selected_fiscal_year]
    }

    CommodityRowGenerator.new(options).generate_rows

    redirect_to edit_commodity_path(@commodity)
  end

  private

    # Allow only these params for update
    def commodity_params
      params.require(:fixed_assets_commodity).permit(
        :name,
        :description,
        :amount,
        :activated_at,
        :planned_depreciation_type,
        :planned_depreciation_amount,
        :btl_depreciation_type,
        :btl_depreciation_amount,
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

    def find_voucher_row
      @voucher_row = current_company.voucher_rows.find(params[:voucher_row_id])
    end

    def linkable_vouchers
      @vouchers = @commodity.linkable_vouchers.includes(:rows)
    end

    def linkable_purchase_orders
      @purchase_orders = @commodity.linkable_invoices.includes(:rows)
    end

    def link_voucher_row
      @voucher_row.commodity_id = @commodity.id
      @voucher_row.save_by current_user
    end

    def unlink_voucher_row
      @voucher_row.commodity_id = nil
      @voucher_row.save_by current_user
    end

    def unlinking_allowed_check
      if !@commodity.allows_unlinking?
        flash.now[:notice] = 'Viimeistä tiliöintiriviä ei voi poistaa aktivoidulta hyödykkeeltä.'
        render :edit
      end
    end
end
