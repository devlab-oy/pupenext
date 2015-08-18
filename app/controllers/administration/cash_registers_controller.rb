class Administration::CashRegistersController < AdministrationController
  def index
    @cash_registers = CashRegister.search_like(search_params).order(order_params)
  end

  def show
    render :edit
  end

  def edit
  end

  def new
    @cash_register = CashRegister.new
    render :edit
  end

  def create
    @cash_register = CashRegister.new(cash_register_params)

    if @cash_register.save_by current_user
      redirect_to cash_registers_path, notice: t('.create_success')
    else
      render :edit
    end
  end

  def update
    if @cash_register.update_by(cash_register_params, current_user)
      redirect_to cash_registers_path, notice: t('.update_success')
    else
      render :edit
    end
  end

  private

    def find_resource
      @cash_register = CashRegister.find(params[:id])
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
