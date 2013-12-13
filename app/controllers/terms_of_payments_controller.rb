class TermsOfPaymentsController < ApplicationController

  # GET /terms_of_payments
  def index
    @terms_of_payments = TermsOfPayment.all
  end

  # # GET /terms_of_payments/1
  # def show
  # end

  # # GET /terms_of_payments/new
  # def new
  #   @terms_of_payment = TermsOfPayment.new
  # end

  # # GET /terms_of_payments/1/edit
  # def edit
  # end

  # # POST /terms_of_payments
  # def create
  #   @terms_of_payment = TermsOfPayment.new(terms_of_payment_params)

  #   if @terms_of_payment.save
  #     redirect_to @terms_of_payment, notice: 'Terms of payment was successfully created.'
  #   else
  #     render action: 'new'
  #   end
  # end

  # # PATCH/PUT /terms_of_payments/1
  # def update
  #   if @terms_of_payment.update(terms_of_payment_params)
  #     redirect_to @terms_of_payment, notice: 'Terms of payment was successfully updated.'
  #   else
  #     render action: 'edit'
  #   end
  # end

  # # DELETE /terms_of_payments/1
  # def destroy
  #   @terms_of_payment.destroy
  #   redirect_to terms_of_payments_url, notice: 'Terms of payment was successfully destroyed.'
  # end

  # private
  #   # Only allow a trusted parameter "white list" through.
  #   def terms_of_payment_params
  #     params[:terms_of_payment].permit(:teksti)
  #   end
end
