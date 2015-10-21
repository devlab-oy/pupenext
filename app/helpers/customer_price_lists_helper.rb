module CustomerPriceListsHelper
  def target_type_options(selected)
    options_for_select([[t('activerecord.models.customer'), 1],
                        [t('activerecord.models.customer_subcategory'), 2]], selected)
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
