module Import::DataImportHelper
  def special_product_keyword_options
    [
      [ 'Avainsana',  'keyword'     ],
      [ 'Lisätieto',  'information' ],
      [ 'Parametri',  'parameter'   ],
    ]
  end

  def customer_category_options(selected)
    options_from_collection_for_select(
      Keyword::CustomerCategory.all,
      :selite,
      :selitetark,
      selected
    )
  end
end
