class BankAccountsController < ApplicationController

  before_action :find_account, only: [:show, :edit, :update]
  helper_method :showing_unused
  helper_method :show_account_name

  def index
    @accounts = current_user.company.bank_accounts
    @accounts = current_user.company.bank_accounts.unused if showing_unused


    @accounts = resource_search(@accounts)
  end

  def edit
  end

  def create
    @bank_account = current_user.company.bank_accounts.build
    @bank_account.attributes = bank_account_params
    @bank_account.muuttaja = current_user.kuka
    @bank_account.laatija = current_user.kuka

    if @bank_account.save
      redirect_to bank_accounts_path, notice: 'Bank account was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    @bank_account.attributes = bank_account_params
    @bank_account.muuttaja = current_user.kuka

    if @bank_account.save
      redirect_to bank_accounts_path, notice: 'Bank account was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def new
    @bank_account = current_user.company.bank_accounts.build
  end

  private

    def show_account_name(value)
      record = current_user.company.accounts.find_by_tilino(value)
      record.nimi unless record.nil?
    end

    def showing_unused
      params[:not_used] ? true : false
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

end
