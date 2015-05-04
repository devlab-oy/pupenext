class Administration::CashRegistersController < AdministrationController

  before_action :get_qualifiers, only: [:new, :show, :edit, :update, :create]
  before_action :get_locations, only: [:new, :show, :edit, :update, :create]

  before_action :check_kassa_account, only: [:create, :update]
  before_action :check_pankkikortti_account, only: [:create, :update]
  before_action :check_luottokortti_account, only: [:create, :update]
  before_action :check_kateistilitys_account, only: [:create, :update]
  before_action :check_kassaerotus_account, only: [:create, :update]
  before_action :check_kateisotto_account, only: [:create, :update]

  def index
    @cash_registers = CashRegister
    .search_like(search_params)
    .order(order_params)
  end

  def show
     render :edit
  end

  def edit
  end

  def new
    @cash_register = CashRegister.new
  end

  def create
    @cash_register = CashRegister.new(cash_register_params)

    @cash_register.kustp = 0 if @cash_register.kustp.nil?

    if @cash_register.save_by current_user
      redirect_to cash_registers_path, notice: "Kassalipas luotiin onnistuneesti"
    else
      render :new
    end
  end

  def update
    if @cash_register.update_by(cash_register_params, current_user)
      redirect_to cash_registers_path, notice: "Kassalipas päivitettiin onnistuneesti"
    else
      render :edit
    end
  end

private

    def find_resource
      @cash_register = CashRegister.find(params[:id])
    end

    def get_qualifiers
      @qualifiers = Qualifier.all.order(:nimi)
    end

    def get_locations
      @locations = Location.all.order(:nimi)
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
      search = params[:cash_register][type]
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

    def cash_register_params
        params.require(:cash_register).permit(
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
