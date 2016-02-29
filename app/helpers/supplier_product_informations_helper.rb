module SupplierProductInformationsHelper
  def show_table?
    params[:supplier].present? || session[:supplier].present?
  end

  def manufacturer_options
    SupplierProductInformation
      .order(:manufacturer_name)
      .pluck(:manufacturer_name)
      .map { |s| [s, "@#{s}"] }
      .uniq
  end
end
