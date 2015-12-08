class SupplierProductInformationsController < ApplicationController
  include ColumnSort

  def index
    render :supplier_selection unless session[:supplier].present?

    session[:supplier] = params[:supplier] if params[:supplier].present?

    @supplier_product_informations = SupplierProductInformation.search_like(search_params)
  end

  private

  def searchable_columns
    %i(
      manufacturer_ean
      manufacturer_part_number
      product_name
      product_id
    )
  end

  def sortable_columns
    searchable_columns
  end
end
