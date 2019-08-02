require 'csv'

class StockListingSpecialCsv < StockListingCsv
  # This is the Special version of StockListingCsv
  # Difference is the output of the data method
  # and the output filename should not be unique

  def to_file
    filename = "#{Dir.tmpdir}/VarastotilannePuutteilla #{Date.today.strftime('%d.%m.%Y')}.csv"

    CSV.open(filename, "wb", @options) do |csv|
      data.map { |row| csv << row }
    end

    filename
  end

  private

    def data
      @data ||= company.products.inventory_management.active.where.not(eankoodi: '').find_each.map do |product|
        row = ProductRow.new product
        myynti6kk = ActiveRecord::Base.connection.execute("select round(sum(rivihinta)) from tilausrivi where tuoteno = #{row.product.tuoteno} and tyyppi ='L' and laskutettuaika >= (DATE_SUB(CURDATE(), INTERVAL 6 MONTH));")
        myynti12kk = ActiveRecord::Base.connection.execute("select round(sum(rivihinta)) from tilausrivi where tuoteno = #{row.product.tuoteno} and tyyppi ='L' and laskutettuaika >= (DATE_SUB(CURDATE(), INTERVAL 12 MONTH));")

        [
	     row.product.tuotemerkki,
         row.product.nimitys,
	     row.product.tuoteno,
         row.stock,
	     row.product.tuoteno,
         row.product.stock_reserved,
         row.product.tuoteno,
         row.coming_in_next_order,
         row.product.tuoteno,
         #var_kiertonop
         row.product.tuoteno,
         myynti6kk,
         row.product.tuoteno,
         myynti12kk,
         row.product.tuoteno,
         row.product.shortage_days
        ]
      end
    end
end
