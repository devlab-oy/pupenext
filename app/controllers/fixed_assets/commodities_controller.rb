class FixedAssets::CommoditiesController < AdministrationController
  before_action :find_resource, except: [:index, :new, :create]
  before_action :find_voucher_row, only: [:link_order, :link_voucher, :unlink]
  before_action :linkable_purchase_orders, only: [:purchase_orders, :link_order]
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
  def link_order
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
  def unlink
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
      flash.now[:notice] = 'Aktivointi epäonnistui'
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
    if @commodity.can_be_sold?(params)
      commodity_sales_params
      @commodity.save_by current_user
      options = {
        commodity_id: @commodity.id,
        user_id: current_user.id
      }
      CommodityRowGenerator.new(options).sell
      redirect_to edit_commodity_path(@commodity), notice: 'Hyödykkeen myynti onnistui.'
    else
      flash.now[:notice] = 'Virheelliset parametrit'
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
      if @voucher_row.commodity_id.blank?
        @voucher_row.commodity_id = @commodity.id
      else
        flash.now[:notice] = 'Tämä rivi on jo lisätty hyödykkeelle.'
        return false
      end

      if @voucher_row.valid?
        @voucher_row.save_by current_user
        @commodity.save_by current_user
      else
        flash.now[:notice] = 'Et voi lisätä tätä riviä.'
        false
      end
    end

    def unlink_voucher_row
      if @commodity.allows_unlinking? && @voucher_row.commodity_id.present?
        @voucher_row.commodity_id = nil
        @voucher_row.save_by current_user
        @commodity.save_by current_user
      else
        flash.now[:notice] = 'Et voi poistaa tätä riviä hyödykkeeltä.'
        false
      end
    end

    def commodity_sales_params
      @commodity.deactivated_at = params[:deactivated_at]
      @commodity.amount_sold    = params[:amount_sold]
      @commodity.profit_account = current_company.accounts.find_by(tilino: params[:profit_account])
      @commodity.sales_account = current_company.accounts.find_by(tilino: params[:sales_account])
      @commodity.depreciation_remainder_handling = params[:depreciation_remainder_handling]
    end
end
