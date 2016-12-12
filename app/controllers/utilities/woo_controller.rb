class Utilities::WooController < ApplicationController
  protect_from_forgery with: :null_session

  skip_before_action :authorize,     :set_current_info, :set_locale, :access_control
  before_action      :api_authorize, :set_current_info, :set_locale, :access_control

  def complete_order
    woo_orders = Woo::Orders.new order_attributes

    # Woo::Orders.complete_order returns true if everything went ok!
    if woo_orders.complete_order(order_params[:order_number], order_params[:tracking_code])
      render json: { message: 'tilaus päivitetty onnistuneesti' }
    else
      render json: { message: 'virhe tilauksen päivityksessä' }, status: :unprocessable_entity
    end
  rescue
    render json: { message: 'internal server error' }, status: :internal_server_error
  end

  private

    def order_params
      params.require(:order).permit(
        :order_number,
        :tracking_code,
      )
    end

    def order_attributes
      {
        store_url: params[:store_url],
        consumer_key: params[:test_key],
        consumer_secret: params[:consumer_secret],
        company_id: current_company.id,
      }
    end
end
