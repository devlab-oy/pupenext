require 'csv'

class StockListingConfigurableCsv < StockListingCsv
  def to_file
    filename = "#{Dir.tmpdir}/stocklisting_new.csv"

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
        .where.not(status: Product.statuses[:order_only])
        .inventory_management
        .where('(tuotemerkki IN (?) AND try IN (?)) OR osasto IN (?)',
               brands_to_include, subcategories_to_include, categories_to_include)

      @data ||= products.find_each.map do |product|
        row = ProductRow.new product, warehouse_ids: warehouses

        [
          row.product.tuoteno,
          row.product.eankoodi,
          row.product.tuotemerkki,
          row.product.nimitys,
          row.stock,
          row.order_date,
          row.coming_in_next_order,
        ]
      end
    end
end
