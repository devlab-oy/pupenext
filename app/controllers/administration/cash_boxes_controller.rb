class Administration::CashBoxesController < AdministrationController

  before_action :get_qualifiers, only: [:new, :show, :edit, :update, :create]
  before_action :get_locations, only: [:new, :show, :edit, :update, :create]

  before_action :check_kassa_account, only: [:create, :update]
  before_action :check_pankkikortti_account, only: [:create, :update]
  before_action :check_luottokortti_account, only: [:create, :update]
  before_action :check_kateistilitys_account, only: [:create, :update]
  before_action :check_kassaerotus_account, only: [:create, :update]
  before_action :check_kateisotto_account, only: [:create, :update]

  def index
    @cash_boxes = current_company.cash_boxes
    .search_like(search_params)
    .order(order_params)
  end

  def show
     render 'edit'
  end

  def edit
  end

  def new
    @cash_box = current_company.cash_boxes.build
  end

def create
    @cash_box = current_company.cash_boxes.build
    @cash_box.attributes = cash_box_params

    if @cash_box.kustp == nil
      @cash_box.kustp = 0
    end

    if @cash_box.save_by current_user
      redirect_to cash_boxes_path, notice: 'Cash box was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @cash_box.update_by(cash_box_params, current_user)
      redirect_to cash_boxes_path, notice: 'Cash box was successfully updated.'
    else
      render action: 'edit'
    end
  end

private

    def find_resource
      @cash_box = current_company.cash_boxes.find(params[:id])
    end

    def get_qualifiers
      @qualifiers = Qualifier.all
    end

    def get_locations
      @locations = Location.all
    end

    def check_kassa_account
      @kassa_accounts = get_accounts(:kassa)
    end

    def check_pankkikortti_account
      @pankkikortti_accounts = get_accounts(:pankkikortti)
    end

    def check_luottokortti_account
      @luottokortti_accounts = get_accounts(:luottokortti)
    end

    def check_kateistilitys_account
      @kateistilitys_accounts = get_accounts(:kateistilitys)
    end

    def check_kassaerotus_account
      @kassaerotus_accounts = get_accounts(:kassaerotus)
    end

    def check_kateisotto_account
      @kateisotto_accounts = get_accounts(:kateisotto)
    end

    def get_accounts(type)
      search = params[:cash_box][type]
      Account.by_name(search) if search.present?
    end

    def searchable_columns
      [
        :nimi,
        :kustp,
        :toimipaikka,
        :kassa,
        :pankkikortti,
        :luottokortti,
        :kateistilitys,
        :kassaerotus,
        :kateisotto
      ]
    end

    def sortable_columns
      searchable_columns
    end

    def cash_box_params
        params.require(:cash_box).permit(
          :nimi,
          :kustp,
          :toimipaikka,
          :kassa,
          :pankkikortti,
          :luottokortti,
          :kateistilitys,
          :kassaerotus,
          :kateisotto
        )
    end

end
