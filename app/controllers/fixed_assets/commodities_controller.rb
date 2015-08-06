class FixedAssets::CommoditiesController < AdministrationController
  before_action :find_resource, except: [:index, :new, :create]
  before_action :find_voucher_row, only: [:link_order, :link_voucher, :unlink]
  before_action :linkable_purchase_orders, only: [:purchase_orders, :link_order]
  before_action :linkable_vouchers, only: [:vouchers, :link_voucher]

  # GET /commodities
  def index
    @commodities = FixedAssets::Commodity
      .search_like(search_params)
      .order(order_params)
  end

   # GET /commodities/1
  def show
    render :edit
  end

  # GET /commodities/new
  def new
    @commodity = FixedAssets::Commodity.new
  end

  # PATCH /commodities/1
  def update
    if @commodity.update_by(commodity_params, current_user)
      redirect_to edit_commodity_path(@commodity), notice: t('.update_success')
    else
      render :edit
    end
  end

  # GET /commodities/1/edit
  def edit
  end

  # POST /commodities
  def create
    @commodity = FixedAssets::Commodity.new(commodity_create_params)

    if @commodity.save_by current_user
      redirect_to edit_commodity_path(@commodity), notice: t('.create_success')
    else
      render :new
    end
  end

  # GET /commodities/1/purchase_orders
  def purchase_orders
  end

  # POST /commodities/1/link_order
  def link_order
    if link_voucher_row
      redirect_to commodity_purchase_orders_path, notice: t('.link_order_success')
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
      redirect_to commodity_vouchers_path, notice: t('.link_voucher_success')
    else
      render :vouchers
    end
  end

  # POST /commodities/1/unlink
  def unlink
    if unlink_voucher_row
      redirect_to edit_commodity_path(@commodity), notice: t('.unlink_success')
    else
      render :edit
    end
  end

  # POST /commodities/1/activate
  def activate
    @commodity.status = 'A'

    if @commodity.save_by current_user
      redirect_to edit_commodity_path(@commodity), notice: t('.activation_success')
    else
      @commodity.status = ''
      flash.now[:notice] = t('.activation_failure')
      render :edit
    end
  end

  def generate_rows
    options = {
      commodity_id: @commodity.id,
      fiscal_id: params[:selected_fiscal_year],
      user_id: current_user.id
    }

    CommodityRowGenerator.new(options).generate_rows

    redirect_to edit_commodity_path(@commodity)
  end

  def sell
  end

  def confirm_sale
    commodity_sales_params

    if @commodity.can_be_sold? && @commodity.save_by(current_user)
      options = {
        commodity_id: @commodity.id,
        user_id: current_user.id
      }
      CommodityRowGenerator.new(options).sell

      redirect_to edit_commodity_path(@commodity), notice: t('.sale_success')
    else
      flash.now[:notice] = t('.sale_failure')
      render :sell
    end
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
      @commodity = FixedAssets::Commodity.find(params[:commodity_id] || params[:id])
    end

    def find_voucher_row
      @voucher_row = Head::VoucherRow.find(params[:voucher_row_id])
    end

    def linkable_vouchers
      @vouchers = @commodity.linkable_vouchers.includes(:rows)
    end

    def linkable_purchase_orders
      @purchase_orders = @commodity.linkable_invoices.includes(:rows)
    end

    def link_voucher_row
      if @voucher_row.commodity_id.blank?
        @voucher_row.commodity_id = @commodity.id
      else
        flash.now[:notice] = t('.row_already_linked')
        return false
      end

      if @voucher_row.valid?
        @voucher_row.save_by current_user
        @commodity.save_by current_user
      else
        flash.now[:notice] = t('.cannot_link_row')
        false
      end
    end

    def unlink_voucher_row
      if @commodity.allows_unlinking? && @voucher_row.commodity_id.present?
        @voucher_row.commodity_id = nil
        @voucher_row.save_by current_user
        @commodity.save_by current_user
      else
        flash.now[:notice] = t('.cannot_unlink')
        false
      end
    end

    def commodity_sales_params
      @commodity.deactivated_at = params[:deactivated_at]
      @commodity.amount_sold    = params[:amount_sold]
      @commodity.profit_account = Account.find_by(tilino: params[:profit_account])
      @commodity.sales_account = Account.find_by(tilino: params[:sales_account])
      @commodity.depreciation_remainder_handling = params[:depreciation_remainder_handling]
    end
end
