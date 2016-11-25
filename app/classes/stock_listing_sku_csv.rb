require 'csv'

class StockListingSkuCsv < StockListingCsv
  # This is the SKU version of StockListingCsv
  # Difference is the output of the data method

  private

    def data
      @data ||= company.products.inventory_management.active.find_each.map do |product|
        row = ProductRow.new product
        [
          row.product.tuoteno,
          row.product.nimitys,
          row.stock,
        ]
      end
    end
end
