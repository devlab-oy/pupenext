class BankAccountsController < ApplicationController

  before_action :find_account, only: [:show, :edit, :update]

  def index
    @accounts = current_user.company.bank_accounts
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

    def find_account
      @bank_account = current_user.company.bank_accounts.find params[:id]
    end

    def bank_account_params
      params[:bank_account].permit(
          :nimi,
          :pankki,
          :kaytossa,
          :tilino,
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
          :pankkitarkenne,
          :asiakastarkenne,
          :salattukerta,
          :siemen,
          :kertaavain,
          :sasukupolvi,
          :kasukupolvi,
          :siirtoavain,
          :kayttoavain,
          :generointiavain,
          :nro,
          :tilinylitys,
          :asiakas
        )
    end

end