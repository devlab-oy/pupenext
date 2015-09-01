class Administration::BankAccountsController < AdministrationController
  helper_method :show_inactive?

  def index
    accounts = show_inactive? ? BankAccount.all : BankAccount.active
    @bank_accounts = accounts.search_like(search_params).order(order_params)
  end

  def edit
  end

  def create
    @bank_account = BankAccount.new bank_account_params

    if @bank_account.save
      redirect_to bank_accounts_path, notice: t('.create_success')
    else
      render :edit
    end
  end

  def update
    if @bank_account.update bank_account_params
      redirect_to bank_accounts_path, notice: t('.update_success')
    else
      render :edit
    end
  end

  def new
    @bank_account = BankAccount.new
    render :edit
  end

  private

    def show_inactive?
      params[:show_inactive] == "yes"
    end

    def find_resource
      @bank_account = BankAccount.find params[:id]
    end

    def bank_account_params
      params.require(:bank_account).permit(resource_parameters(BankAccount,
        :nimi,
        :asiakastunnus,
        :bic,
        :factoring,
        :hyvak,
        :iban,
        :kaytossa,
        :maksulimitti,
        :oletus_kohde,
        :oletus_kulutili,
        :oletus_kustp,
        :oletus_projekti,
        :oletus_rahatili,
        :oletus_selvittelytili,
        :tilino,
        :tilinylitys,
        :valkoodi,
      ))
    end

    def searchable_columns
      [:nimi, :iban, :maksulimitti, :oletus_kulutili, :oletus_rahatili, :oletus_selvittelytili]
    end

    def sortable_columns
      searchable_columns
    end
end
