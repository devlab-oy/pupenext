require 'csv'

class StockListingConfigurableCsv < StockListingCsv
  def to_file
    filename = "#{Dir.tmpdir}/Varastosaldot FIN CSV #{Time.zone.today.strftime('%d.%m.%Y')}.csv"

    CSV.open(filename, 'wb', @options) do |csv|
      data.map { |row| csv << row }
    end

    filename
  end

  private

    def data
      brands_to_include        = Keyword::StockListingFilter.brands_to_include
      subcategories_to_include = Keyword::StockListingFilter.subcategories_to_include
      categories_to_include    = Keyword::StockListingFilter.categories_to_include

      products = company
        .products
        .active
        .inventory_management
        .where('(tuotemerkki IN (?) AND try IN (?)) OR osasto IN (?)',
               brands_to_include, subcategories_to_include, categories_to_include)

      @data ||= products.find_each.map do |product|
        row = ProductRow.new product, warehouse_ids: warehouses

        [
          row.product.eankoodi,
          row.product.tuoteno,
          row.product.nimitys,
          row.stock,
          row.order_date,
          row.coming_in_next_order,
        ]
      end
    end
end
