class Administration::BankAccountsController < AdministrationController
  helper_method :show_used?

  def index
    accounts = show_used? ? BankAccount.active : BankAccount.all
    @bank_accounts = accounts.search_like(search_params).order(order_params)
  end

  def edit
  end

  def create
    @bank_account = BankAccount.new bank_account_params

    if @bank_account.save
      redirect_to bank_accounts_path, notice: "Uusi pankkitili perustettu"
    else
      render :edit
    end
  end

  def update
    if @bank_account.update bank_account_params
      redirect_to bank_accounts_path, notice: "Pankkitili päivitettiin onnistuneesti"
    else
      render :edit
    end
  end

  def new
    @bank_account = BankAccount.new
    render :edit
  end

  private

    def show_used?
      params[:not_used] != "yes"
    end

    def find_resource
      @bank_account = BankAccount.find params[:id]
    end

    def bank_account_params
      params.require(:bank_account).permit(
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
        :tilinylitys,
        :valkoodi,
      )
    end

    def searchable_columns
      [:nimi, :iban, :maksulimitti, :oletus_kulutili, :oletus_rahatili, :oletus_selvittelytili]
    end

    def sortable_columns
      searchable_columns
    end
end
