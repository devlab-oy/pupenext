require 'csv'

class StockListingCsv
  attr_reader :company

  def initialize(company_id:, column_separator: ',', warehouse_ids: nil)
    @company = Company.find company_id
    Current.company = @company

    @options = { col_sep: column_separator }
    @warehouse_ids = warehouse_ids
  end

  def csv_data
    CSV.generate(@options) do |csv|
      data.map { |row| csv << row }
    end
  end

  def to_file
    filename = Tempfile.new ['stock_listing-', '.csv']

    CSV.open(filename, 'wb', @options) do |csv|
      data.map { |row| csv << row }
    end

    filename.path
  end

  private

    def data
      @data ||= company.products.inventory_management.active.find_each.map do |product|
        row = ProductRow.new product, warehouse_ids: warehouses


        6kk_sql = "select round(sum(rivihinta)) from tilausrivi where tuoteno = #{row.product.tuoteno} and tyyppi ='L' and laskutettuaika >= (DATE_SUB(CURDATE(), INTERVAL 6 MONTH));"
        12kk_sql = "select round(sum(rivihinta)) from tilausrivi where tuoteno = #{row.product.tuoteno} and tyyppi ='L' and laskutettuaika >= (DATE_SUB(CURDATE(), INTERVAL 12 MONTH));"
        
        myynti6kk = ActiveRecord::Base.connection.execute(6kk_sql)
        myynti12kk = ActiveRecord::Base.connection.execute(12kk_sql)

        [
	       row.product.tuotemerkki,
         row.product.nimitys,
	       row.product.tuoteno,
         row.stock,
	       row.product.tuoteno,
         row.product.stock_reserved,
         row.product.tuoteno,
         row.product.coming_in_next_order
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

    def warehouses
      return if @warehouse_ids.blank?

      return @warehouse_ids if @warehouse_ids.is_a?(Array)

      @warehouse_ids.to_s.split(',')
    end
end

class StockListingCsv::ProductRow
  attr_reader :product, :warehouse_ids

  def initialize(product, warehouse_ids: nil)
    @product = product
    @warehouse_ids = warehouse_ids
  end

  def stock
    stock = stock_raw < 0 ? 0.0 : stock_raw

    # show decimals only if they matter (% short for sprintf)
    '%g' % stock
  end

  def stock_after_order
    stock = next_order ? (stock_raw + next_order.varattu) : nil
    stock && stock > 0 ? ('%g' % stock) : nil
  end

  def order_date
    next_order ? next_order.toimaika : nil
  end

  def coming_in_next_order
    next_order && next_order.varattu && format('%g', next_order.varattu)
  end

  private

    def stock_raw
      @stock ||= Stock.new(product, warehouse_ids: warehouse_ids).stock_available
    end

    def next_order
      @next_order ||= product.purchase_order_rows.open.order(:toimaika).first
    end
end
