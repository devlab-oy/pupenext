class StocksController < ApplicationController
  protect_from_forgery with: :null_session

  skip_before_action :authorize,     :set_current_info, :set_locale, :access_control
  before_action      :api_authorize, :set_current_info, :set_locale, :access_control, :find_product

  def stock_available_per_warehouse
    unless params[:warehouse_ids] && params[:warehouse_ids].respond_to?(:each_with_object)
      return render json: { error: 'warehouse_ids parameter is required' }, status: :bad_request
    end

    stock = Stock.new(@product, warehouse_ids: params[:warehouse_ids]).stock_available_per_warehouse

    render json: stock
  end

  private

    def find_product
      @product ||= Product.find(params[:product_id])
    end
end
