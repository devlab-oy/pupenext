class SupplierProductInformationsController < ApplicationController
  include ColumnSort

  def index
    @supplier_product_informations = SupplierProductInformation.search_like(search_params)
  end

  private

  def searchable_columns
    %i(
      product_name
    )
  end

  def sortable_columns
    searchable_columns
  end
end
