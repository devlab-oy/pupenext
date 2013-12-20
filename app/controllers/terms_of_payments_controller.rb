class TermsOfPaymentsController < ApplicationController

  before_action :find_terms_of_payment, only: [:show, :edit, :update]

  # GET /terms_of_payments
  def index
    @terms_of_payments = TermsOfPayment.all
  end

  # GET /terms_of_payments/1
  def show
    render 'edit'
  end

  # GET /terms_of_payments/new
  def new
    @terms_of_payment = TermsOfPayment.new
  end

  # GET /terms_of_payments/1/edit
  def edit
  end

  # POST /terms_of_payments
  def create
    @terms_of_payment = TermsOfPayment.new
    @terms_of_payment.attributes = terms_of_payment_params
    @terms_of_payment.muuttaja = current_user.kuka
    @terms_of_payment.laatija = current_user.kuka
    @terms_of_payment.yhtio = current_user.yhtio

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
        :osamaksuehto1,
        :osamaksuehto2,
        :summanjakoprososa2,
        :jv,
        :kateinen,
        :suoraveloitus,
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
      @terms_of_payment = TermsOfPayment.find(params[:id])
    end
end
