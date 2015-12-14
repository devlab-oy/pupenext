class SupplierProductInformationsController < ApplicationController
  include ColumnSort

  def index
    session[:supplier] = params[:supplier] if params[:supplier].present?

    if session[:supplier].present? && search_params.present?
      @supplier                      = Supplier.find(session[:supplier])
      @supplier_product_informations = @supplier.supplier_product_informations.search_like(search_params)
    else
      @supplier_product_informations = SupplierProductInformation.none
    end
  end

  def transfer
    @supplier_product_informations = SupplierProductInformation.find(supplier_product_informations_params.keys)

    supplier = Supplier.find(session[:supplier])

    @supplier_product_informations.each do |s|
      s.create_product(
        alv:      24,
        eankoodi: s.manufacturer_ean,
        nimitys:  s.product_name,
        status:   Product::Status.find_by(selite: 'A'),
        tuoteno:  s.manufacturer_part_number
      )

      supplier.product_suppliers.create(
        tehdas_saldo:            s.available_quantity,
        tehdas_saldo_paivitetty: Time.now,
        toim_nimitys:            s.product_name,
        toim_tuoteno:            s.product_id,
        tuoteno:                 s.manufacturer_part_number
      )
    end

    redirect_to supplier_product_informations_url
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

  def supplier_product_informations_params
    permitted = {}

    params[:supplier_product_informations].keys.each do |tunnus|
      permitted[tunnus] = '1'
    end

    params.require(:supplier_product_informations).permit(permitted)
  end
end
