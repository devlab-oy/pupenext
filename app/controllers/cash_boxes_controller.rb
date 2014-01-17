class CashBoxesController < ApplicationController

  before_action :find_cash_box, only: [:show, :edit, :update]
  before_action :get_qualifiers, only: [:new, :show, :edit, :update, :create]
  before_action :get_locations, only: [:new, :show, :edit, :update, :create]
  before_action :check_kassa_account, only: [:create, :update]
  before_action :check_pankkikortti_account, only: [:create, :update]
  before_action :check_luottokortti_account, only: [:create, :update]
  before_action :check_kateistilitys_account, only: [:create, :update]
  before_action :check_kassaerotus_account, only: [:create, :update]


  def index
    @cash_boxes = current_user.company.cash_boxes
  end

  def show
     render 'edit'
     @account_names = get_account_names
  end

  def new
    @cash_box = current_user.company.cash_boxes.build
    @account_names = get_account_names
  end

def create
    @cash_box = current_user.company.cash_boxes.build
    @cash_box.attributes = cash_box_params
    @cash_box.created_by = current_user.kuka
    @cash_box.updated_by = current_user.kuka
    @account_names = get_account_names

    if @cash_box.save
      redirect_to cash_boxes_path, notice: 'Cash box was successfully created.'
    else
      render action: 'new'
    end
  end

  def edit
    @account_names = get_account_names
  end

  def update
    @cash_box.attributes = cash_box_params
    @cash_box.created_by = current_user.kuka

    if @cash_box.save
      redirect_to cash_boxes_path, notice: 'Cash box was successfully updated.'
    else
      @account_names = get_account_names
      render action: 'edit'
    end
  end

private

    def find_cash_box
      @cash_box = current_user.company.cash_boxes.find(params[:id])
    end

    def get_qualifiers
      @qualifiers = Qualifier.all
    end

    def get_locations
      @locations = Location.all
    end

    def check_kassa_account
      if( check_accounts('kassa') )
        @kassa_account = get_account('kassa')
      else
        @kassa_accounts = get_accounts('kassa')
      end
    end

    def check_pankkikortti_account
      if( check_accounts('pankkikortti') )
        @pankkikortti_account = get_account('pankkikortti')
      else
        @pankkikortti_accounts = get_accounts('pankkikortti')
      end
    end

    def check_luottokortti_account
      if( check_accounts('luottokortti') )
        @luottokortti_account = get_account('luottokortti')
      else
        @luottokortti_accounts = get_accounts('luottokortti')
      end
    end

    def check_kateistilitys_account
      if( check_accounts('kateistilitys') )
        @kateistilitys_account = get_account('kateistilitys')
      else
        @kateistilitys_accounts = get_accounts('kateistilitys')
      end
    end

    def check_kassaerotus_account
      if( check_accounts('kassaerotus') )
        @kassaerotus_account = get_account('kassaerotus')
      else
        @kassaerotus_accounts = get_accounts('kassaerotus')
      end
    end



    def check_accounts(type)
      account_found = Account.where("tilino = ?", params[:cash_box][type]).size
      accounts_found = Account.where("nimi like ?", "%#{params[:cash_box][type]}%").size
      if( account_found != 1 && accounts_found > 1 )
        return false
      else
        return true
      end
    end

    def get_account(type)
      account = Account.where("tilino = ?", params[:cash_box][type])
    end

    def get_old_account(type)
      account = Account.where("tilino = ?", @cash_box[type])
    end

    def get_account_name_by_tilino(tilino)
      account = Account.where("tilino = ?", tilino).to_a

      if( account.size == 1 )
        name = account[0][:nimi]
      else
        name = ''
      end
    end


    def get_account_names
        @kassa = get_account_name_by_tilino(@cash_box['kassa'])
        @pankkikortti = get_account_name_by_tilino(@cash_box['pankkikortti'])
        @luottokortti = get_account_name_by_tilino(@cash_box['luottokortti'])
        @kateistilitys = get_account_name_by_tilino(@cash_box['kateistilitys'])
        @kassaerotus = get_account_name_by_tilino(@cash_box['kassaerotus'])
    end

    def get_accounts(type)
      params[:cash_box][type] == '' ? search = nil : search = params[:cash_box][type]
      accounts = Account.where("nimi LIKE ?", "%#{search}%") if search.present?

      #if(accounts.to_a.size > 0)
        case type
        when 'kassa'
          @kassa_accounts = accounts
        when 'pankkikortti'
          @pankkikortti_accounts = accounts
        when 'luottokortti'
          @luottokortti_accounts = accounts
        when 'kateistilitys'
          @kateistilitys_accounts = accounts
        when 'kassaerotus'
          @kassaerotus_accounts = accounts
        end
      #end
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
