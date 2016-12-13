class StocksController < ApplicationController
  protect_from_forgery with: :null_session

  skip_before_action :authorize,     :set_current_info, :set_locale, :access_control
  before_action      :api_authorize, :set_current_info, :set_locale, :access_control, :find_product

  def stock_available_per_warehouse
    stock = Stock.new(@product, warehouse_ids: stock_parameters[:warehouse_ids])

    render json: stock.stock_available_per_warehouse.to_json
  rescue ActionController::ParameterMissing => e
    render json: { message: e.to_s }, status: :bad_request
  rescue
    render json: { message: 'internal server error' }, status: :internal_server_error
  end

  private

    def find_product
      @product ||= Product.find(params[:product_id])
    end

    def stock_parameters
      params.require(:warehouse_ids)
      params.permit(warehouse_ids: [])
    end
end
