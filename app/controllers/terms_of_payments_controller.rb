class TermsOfPaymentsController < ApplicationController

  before_action :find_terms_of_payment, only: [:show, :edit, :update]
  before_action :find_all_terms_of_payments

  # GET /terms_of_payments
  def index
    @terms_of_payments = current_user.company.terms_of_payments.where(kaytossa: '')
    @terms_of_payments = resource_search(@terms_of_payments)

    @not_used = false
  end

  def not_used
    @terms_of_payments = current_user.company.terms_of_payments.where(kaytossa: 'E')
    @not_used = true

    render 'index'
  end

  # GET /terms_of_payments/1
  def show
    render 'edit'
  end

  # GET /terms_of_payments/new
  def new
    @terms_of_payment = current_user.company.terms_of_payments.build
  end

  # GET /terms_of_payments/1/edit
  def edit
  end

  # POST /terms_of_payments
  def create
    @terms_of_payment = current_user.company.terms_of_payments.build
    @terms_of_payment.attributes = terms_of_payment_params
    @terms_of_payment.muuttaja = current_user.kuka
    @terms_of_payment.laatija = current_user.kuka

    if @terms_of_payment.save
      redirect_to terms_of_payments_path, notice: 'Terms of payment was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /terms_of_payments/1
  def update

    @terms_of_payment.attributes = terms_of_payment_params
    @terms_of_payment.muuttaja = current_user.kuka

    if @terms_of_payment.save
      redirect_to terms_of_payments_path, notice: 'Terms of payment was successfully updated.'
    else
      render action: 'edit'
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def terms_of_payment_params
      params[:terms_of_payment].permit(
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

    def find_terms_of_payment
      @terms_of_payment = current_user.company.terms_of_payments.find(params[:id])
    end

    def find_all_terms_of_payments
      @terms_of_payments = current_user.company.terms_of_payments.order(:jarjestys, :teksti)
    end
end
