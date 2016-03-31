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

  def category_text_options(number)
    options_from_collection_for_select(SupplierProductInformation.category_texts(number),
                                       "category_text#{number}",
                                       "category_text#{number}",
                                       params["category_text#{number}"])
  end
end
