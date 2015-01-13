class Administration::AccountsController < AdministrationController
  before_action :fetch_options_for_selects, only: [:new, :edit, :show]

  def index
    @accounts = current_company
      .accounts
      .includes(:internal, :external, :vat)
      .search_like(search_params)
      .order(order_params)
  end

  def new
    @account = current_company.accounts.build
  end

  def show
    render :edit
  end

  def create
    @account = current_company.accounts.build(account_params)

    if @account.save_by current_user
      redirect_to accounts_path, notice: 'Uusi tili perustettu'
    else
      fetch_options_for_selects
      render :new
    end
  end

  def edit
  end

  def update
    if @account.update_by account_params, current_user
      redirect_to accounts_path, notice: 'Tili päivitettiin onnistuneesti'
    else
      fetch_options_for_selects
      render :edit
    end
  end

  def destroy
    @account.destroy
    redirect_to accounts_path, notice: "Tili poistettiin onnistuneesti"
  end

  private

    def find_resource
      @account = current_company.accounts.find params[:id]
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
        :projekti,
        :toimijaliitos,
        :tiliointi_tarkistus,
        :manuaali_esto,
        :oletus_alv
      )
    end

    def searchable_columns
      [
        :tilino,
        :nimi,
        :sisainen_taso,
        :ulkoinen_taso,
        :alv_taso
      ]
    end

    def sortable_columns
      searchable_columns
    end

    def fetch_options_for_selects
      @levels = {
        internal: current_company.sum_level_internals,
        external: current_company.sum_level_externals,
        vat: current_company.sum_level_vats,
        profit: current_company.sum_level_profits
      }

      cc = current_company.cost_centers.order("koodi+0, koodi, nimi")
      cc << current_company.cost_centers.build(tunnus: 0, nimi: 'Ei kustannuspaikkaa')

      ta = current_company.targets.order("koodi+0, koodi, nimi")
      ta << current_company.targets.build(tunnus: 0, nimi: 'Ei kohdetta')

      pr = current_company.projects.order("koodi+0, koodi, nimi")
      pr << current_company.projects.build(tunnus: 0, nimi: 'Ei projektia')

      @qualifiers = {
        cost_center: cc,
        target: ta,
        project: pr
      }

      @oletus_alv_options = current_company
        .keywords
        .vat_percents
        .order("selite+0, laji, jarjestys, selite")
    end
end
