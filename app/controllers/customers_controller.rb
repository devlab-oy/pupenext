class CustomersController < ApplicationController
  protect_from_forgery with: :null_session

  skip_before_filter :authorize, :set_current_info, :set_locale, :access_control
  before_filter :api_authorize, :set_current_info, :set_locale

  def create
    @customer = current_company.customers.build(customer_params)

    if @customer.save
      render json: @customer, status: :created
    else
      render json: { error_messages: @customer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @customer = current_company.customers.find(params[:id])

    if @customer.update(customer_params)
      render json: @customer
    else
      render json: { error_messages: @customer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def find_by_email
    customer = Customer.find_by_email(find_by_params[:email])

    if customer
      render json: customer
    else
      render json: { error_messages: "Not found" }, status: :not_found
    end
  end

  private

    def customer_params
      params.require(:customer).permit(
        :alv,
        :asiakasnro,
        :email,
        :kauppatapahtuman_luonne,
        :kuljetusvakuutus_tyyppi,
        :lahetetyyppi,
        :maa,
        :maksuehto,
        :nimi,
        :nimitark,
        :osasto,
        :osoite,
        :postino,
        :postitp,
        :puhelin,
        :rahtivapaa,
        :ryhma,
        :sisviesti1,
        :tilino,
        :toimitustapa,
        :ytunnus
      )
    end

    def find_by_params
      params.permit(:email)
    end

    def api_authorize
      @current_user = User.unscoped.find_by_api_key(params[:access_token])
      head :unauthorized unless @current_user
    end
end
