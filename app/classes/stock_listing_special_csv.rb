require 'csv'

class StockListingSpecialCsv < StockListingCsv
  # This is the Special version of StockListingCsv
  # Difference is the output of the data method
  # and the output filename should not be unique

  def to_file
    filename = "#{Dir.tmpdir}/VarastotilannePuutteilla #{Date.today.strftime('%d.%m.%Y')}.csv"
    
    CSV.open(filename, "wb+", @options) do |csv|
      headers = ['Tuotemerkki','Tuotenimi','Tuotekoodi','Saldo','Tuotekoodi','Menossa','Tuotekoodi','Tulossa','Tuotekoodi','Myynti 6kk','Tuotekoodi','Myynti 12kk','Tuotekoodi','Loppu pv/12kk']
      csv << headers if csv.count.eql? 0
      data.map { |row| csv << row }
    end

    filename
  end

  private

    def data
      @data ||= company.products.inventory_management.active.find_all.map do |product|
      
      row = ProductRow.new product
        myynti6kk = ActiveRecord::Base.connection.exec_query("select round(sum(kpl)) from tilausrivi where tuoteno = '#{row.product.tuoteno}' and tyyppi ='L' and laskutettuaika >= (DATE_SUB(CURDATE(), INTERVAL 6 MONTH));").rows.first.first
        myynti12kk = ActiveRecord::Base.connection.exec_query("select round(sum(kpl)) from tilausrivi where tuoteno = '#{row.product.tuoteno}' and tyyppi ='L' and laskutettuaika >= (DATE_SUB(CURDATE(), INTERVAL 12 MONTH));").rows.first.first

        reserved_query = ActiveRecord::Base.connection.exec_query("SELECT sum(if(tilausrivi.tyyppi in ('W','M'), tilausrivi.varattu, 0)) valmistuksessa, sum(if(tilausrivi.tyyppi = 'O', tilausrivi.varattu, 0)) tilattu, sum(if(tilausrivi.tyyppi = 'E' and tilausrivi.var != 'O', tilausrivi.varattu, 0)) ennakot, sum(if(tilausrivi.tyyppi in ('L','V') and tilausrivi.var not in ('P','J','O','S'), tilausrivi.varattu, 0)) ennpois, sum(if(tilausrivi.tyyppi in ('L','G') and tilausrivi.var = 'J', tilausrivi.varattu, 0)) jt FROM tilausrivi use index (yhtio_tyyppi_tuoteno_laskutettuaika) WHERE tilausrivi.yhtio        = 'gyms' and tilausrivi.tyyppi  in ('L','V','O','G','E','W','M') and tilausrivi.tuoteno        = '#{row.product.tuoteno}' and tilausrivi.laskutettuaika = '0000-00-00' and (tilausrivi.varattu + tilausrivi.jt > 0);").rows.first

        reserved = reserved_query[2].to_i + reserved_query[3].to_i + reserved_query[4].to_i

        [
	       row.product.tuotemerkki,
         row.product.nimitys,
	       row.product.tuoteno,
         row.stock_physical,
	       row.product.tuoteno,
         reserved,
         row.product.tuoteno,
         row.coming_in_all_orders,
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
