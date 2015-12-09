class SupplierProductInformationsController < ApplicationController
  include ColumnSort

  def index
    session[:supplier] = params[:supplier] if params[:supplier].present?

    if search_params.present?
      @supplier_product_informations = SupplierProductInformation.search_like(search_params)
    else
      @supplier_product_informations = SupplierProductInformation.none
    end
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
