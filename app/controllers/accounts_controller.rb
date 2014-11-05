class AccountsController < ApplicationController

  before_action :find_account, only: [:show, :edit, :update]
  before_action :get_qualifiers, only: [:new, :show, :edit, :update, :create]
  before_action :get_levels, only: [:new, :show, :edit, :update, :create]

  def index
    @accounts = current_user.company.accounts
  end

  def show
    render 'edit'
  end

  def edit
  end

  def new
    @account = current_user.company.accounts.build
  end

  def create
    @account = current_user.company.accounts.build
    @account.attributes = account_params

    if @account.kustp == nil
      @account.kustp = 0
    end

    if @account.save_by current_user
      redirect_to accounts_path, notice: 'Uusi tili perustettu.'
    else
      render action: 'new'
    end
  end

  def update
    if @account.update_by account_params, current_user
      redirect_to accounts_path, notice: "Tilin \"#{params[:account][:nimi]}\"  tiedot päivitetty."
    else
      render action: 'edit'
    end
  end

  def destroy
    Account.destroy params[:id]
    redirect_to accounts_path, notice: "Tili \"#{params[:account][:nimi]}\" poistettu."
  end


  private

    def find_account
      @account = current_user.company.accounts.find(params[:id])
    end

    def get_levels
      @inner_levels = Level.where tyyppi: 'S'
      @outer_levels = Level.where tyyppi: 'U'
      @alv_levels = Level.where tyyppi: 'A'
      @tulosseuranta_levels = Level.where tyyppi: 'B'
    end

    def get_qualifiers
      @default_qualifiers = Qualifier.where tyyppi: 'K'
      @target_qualifiers = Qualifier.where tyyppi: 'O'
    end

    def account_params
      params.require(:account).permit(
        :tilino,
        :sisainen_taso,
        :ulkoinen_taso,
        :alv_taso,
        :tulosseuranta_taso,
        :nimi,
        :kustp,
        :kohde,
        :toimijaliitos,
        :tiliointi_tarkistus,
        :manuaali_esto,
        :oletus_alv
      )
    end

end
