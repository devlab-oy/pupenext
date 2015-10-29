module CustomerPriceListsHelper
  def target_type_options(selected)
    options_for_select([[Customer.model_name.human, 1],
                        [Keyword::CustomerSubcategory.model_name.human, 2]], selected)
  end

  def customer_subcategory_options(selected)
    options_from_collection_for_select Keyword::CustomerSubcategory.all,
                                       :selite,
                                       :selitetark,
                                       selected
  end

  def contract_filter_options(selected)
    options_for_select([[t('.all_products'), 1], [t('.contract_prices'), 2]], selected)
  end
end
