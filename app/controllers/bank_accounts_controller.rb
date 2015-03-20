class BankAccountsController < ApplicationController

  before_action :find_account, only: [:show, :edit, :update]
  helper_method :showing_unused
  helper_method :show_account_name

  def index
    @bank_accounts =
      case showing_unused
      when true
        current_company
          .bank_accounts
          .search_like(search_params)
          .order(order_params)
      else
        current_company
          .bank_accounts
          .in_use
          .search_like(search_params)
          .order(order_params)
      end
  end

  def edit
  end

  def create
    @bank_account = current_company.bank_accounts.build(bank_account_params)

    if @bank_account.save_by current_user
      redirect_to bank_accounts_path, notice: "Uusi pankkitili perustettu"
    else
      render :new
    end
  end

  def update
    if @bank_account.update_by bank_account_params, current_user
      redirect_to bank_accounts_path, notice: "Pankkitili päivitettiin onnistuneesti"
    else
      render :edit
    end
  end

  def new
    @bank_account = current_company.bank_accounts.build
  end

  private

    def show_account_name(value)
      current_company.accounts.find_by_tilino(value).try(:nimi)
    end

    def showing_unused
      params[:not_used] == "yes"
    end

    def find_account
      @bank_account = current_user.company.bank_accounts.unscoped.find(params[:id])
    end

    def bank_account_params
      params.require(:bank_account).permit(
        :nimi,
        :kaytossa,
        :iban,
        :bic,
        :valkoodi,
        :factoring,
        :asiakastunnus,
        :maksulimitti,
        :hyvak,
        :oletus_kulutili,
        :oletus_kustp,
        :oletus_kohde,
        :oletus_projekti,
        :oletus_rahatili,
        :oletus_selvittelytili,
        :tilinylitys
      )
    end

    def searchable_columns
      [:nimi, :tilino, :maksulimitti, :oletus_kulutili, :oletus_rahatili, :oletus_selvittelytili]
    end

    def sortable_columns
      searchable_columns
    end

end
