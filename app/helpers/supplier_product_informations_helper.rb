module SupplierProductInformationsHelper
  def show_table?
    params[:supplier].present? || session[:supplier].present?
  end
end
