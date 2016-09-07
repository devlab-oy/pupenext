class StocksController < ApplicationController
  protect_from_forgery with: :null_session

  skip_before_action :authorize,     :set_current_info, :set_locale, :access_control
  before_action      :api_authorize, :set_current_info, :set_locale, :access_control, :find_product

  def stock_available
    unless params[:warehouse_ids] && params[:warehouse_ids].respond_to?(:each_with_object)
      return render json: { error: 'warehouse_ids parameter is required' }, status: :bad_request
    end

    stock_available = params[:warehouse_ids].each_with_object({}) do |warehouse_id, stocks|
      stocks[warehouse_id] = Stock.new(@product, warehouse_ids: [warehouse_id]).stock_available
    end

    render json: stock_available
  end

  private

    def find_product
      @product ||= Product.find(params[:product_id])
    end
end
