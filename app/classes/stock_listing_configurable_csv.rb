require 'csv'

class StockListingConfigurableCsv < StockListingCsv
  def to_file
    filename = Tempfile.new ['Varastosaldot FIN CSV ', '.csv']

    CSV.open(filename, 'wb', @options) do |csv|
      data.map { |row| csv << row }
    end

    filename.path
  end

  private

    def data
      brands_to_include = Keyword::StockListingFilter.where(selite: 'tuotemerkki').where(selitetark: 'on').pluck(:selitetark_2)
      brands_to_include = brands_to_include.empty? ? Product::Brand.all.pluck(:selite) : brands_to_include
      brands_to_exclude = Keyword::StockListingFilter.where(selite: 'tuotemerkki').where(selitetark: 'off').pluck(:selitetark_2)
      brands_to_include -= brands_to_exclude

      subcategories_to_include = Keyword::StockListingFilter.where(selite: 'try').where(selitetark: 'on').pluck(:selitetark_2)
      subcategories_to_include = subcategories_to_include.empty? ? Product::Subcategory.all.pluck(:selite) : subcategories_to_include
      subcategories_to_exclude = Keyword::StockListingFilter.where(selite: 'try').where(selitetark: 'off').pluck(:selitetark_2)
      subcategories_to_include -= subcategories_to_exclude

      categories_to_include = Keyword::StockListingFilter.where(selite: 'osasto').where(selitetark: 'on').pluck(:selitetark_2)
      categories_to_include = categories_to_include.empty? ? Product::Category.all.pluck(:selite) : categories_to_include
      categories_to_exclude = Keyword::StockListingFilter.where(selite: 'osasto').where(selitetark: 'off').pluck(:selitetark_2)
      categories_to_include -= categories_to_exclude

      products = company
        .products
        .where(tuotemerkki: brands_to_include)
        .where(try: subcategories_to_include)
        .where(osasto: categories_to_include)
        .inventory_management
        .active

      @data ||= products.find_each.map do |product|
        row = ProductRow.new product, warehouse_ids: warehouses

        [
          row.product.tuoteno,
          row.product.eankoodi,
          row.product.nimitys,
          row.stock,
          row.order_date,
          row.stock_after_order,
        ]
      end
    end
end
