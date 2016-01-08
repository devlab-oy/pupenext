module Import::DataImportHelper
  def special_product_keyword_options
    [
      [ 'Avainsana',  'keyword'     ],
      [ 'Lisätieto',  'information' ],
      [ 'Parametri',  'parameter'   ],
    ]
  end

  def customer_sales_month_options
    opt = (1..12).each { |m| [m, m] }
  end

  def customer_sales_year_options
    opt = ((Date.today.year-5)..(Date.today.year+5)).each { |y| [y, y] }
  end
end
