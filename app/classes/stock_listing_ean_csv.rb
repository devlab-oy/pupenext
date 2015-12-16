require 'csv'

class StockListingEanCsv < StockListingCsv
  # This is the EAN version of StockListingCsv
  # Difference is the product query and output of the data method
  # and the output filename should not be unique

  def to_file
    filename = "#{Dir.tmpdir}/Varastotilanne #{Date.today.strftime('%d.%m.%Y')}.csv"

    CSV.open(filename, "wb", @options) do |csv|
      data.map { |row| csv << row }
    end

    filename
  end

  private

    def data
      @data ||= company.products.inventory_management.active.where.not(eankoodi: '').find_each.map do |product|
        row = ProductRow.new product

        [
          row.product.eankoodi,
          row.product.nimitys,
          row.stock,
        ]
      end
    end
end
