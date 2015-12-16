require 'csv'

class StockListingEanCsv < StockListingCsv
  # This is the EAN version of StockListingCsv
  # Only difference is the product query and output of the data method

  private

    def data
      @data ||= company.products.active.where.not(eankoodi: '').find_each.map do |product|
        row = ProductRow.new product

        [
          row.product.eankoodi,
          row.product.nimitys,
          row.stock,
        ]
      end
    end
end
