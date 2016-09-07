class StocksController < ApplicationController
  protect_from_forgery with: :null_session

  skip_before_action :authorize,     :set_current_info, :set_locale, :access_control
  before_action      :api_authorize, :set_current_info, :set_locale, :access_control

  def stock_available
    stock_available = params[:warehouse_ids].each_with_object({}) do |warehouse_id, stocks|
      stocks[warehouse_id] = Stock.new(Product.find(params[:product_id]), warehouse_ids: [warehouse_id]).stock_available
    end

    render json: stock_available
  end
end
