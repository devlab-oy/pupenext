class Administration::TermsOfPaymentsController < AdministrationController
  helper_method :showing_not_used?

  # GET /terms_of_payments
  def index
    top = TermsOfPayment
      .search_like(search_params)
      .order(order_params)

    if showing_not_used?
      @terms_of_payments = top.not_in_use
    else
      @terms_of_payments = top.in_use
    end
  end

  # GET /terms_of_payments/1
  def show
    render :edit
  end

  # GET /terms_of_payments/new
  def new
    @terms_of_payment = TermsOfPayment.new
    render :edit
  end

  # GET /terms_of_payments/1/edit
  def edit
  end

  # POST /terms_of_payments
  def create
    @terms_of_payment = TermsOfPayment.new(terms_of_payment_params)

    if @terms_of_payment.save_by current_user
      redirect_to terms_of_payments_path, notice: t('.create_success')
    else
      render :edit
    end
  end

  # PATCH/PUT /terms_of_payments/1
  def update
    if @terms_of_payment.update_by(terms_of_payment_params, current_user)
      redirect_to terms_of_payments_path, notice: t('.update_success')
    else
      render :edit
    end
  end

  private

    def terms_of_payment_params
      params.require(:terms_of_payment).permit(
        :teksti,
        :rel_pvm,
        :abs_pvm,
        :kassa_relpvm,
        :kassa_abspvm,
        :kassa_alepros,
        :jv,
        :kateinen,
        :factoring,
        :pankkiyhteystiedot,
        :itsetulostus,
        :jaksotettu,
        :erapvmkasin,
        :sallitut_maat,
        :kaytossa,
        :jarjestys
      )
    end

    def find_resource
      @terms_of_payment = TermsOfPayment.find(params[:id])
    end

    def showing_not_used?
      params[:not_used] ? true : false
    end

    def searchable_columns
      [
        :jarjestys,
        :teksti,
        :rel_pvm,
        :abs_pvm,
        :kassa_relpvm,
        :kassa_abspvm,
        :kassa_alepros,
      ]
    end

    def sortable_columns
      searchable_columns
    end
end
