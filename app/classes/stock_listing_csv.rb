require 'csv'

class StockListingCsv
  def initialize(company_id:, column_separator: ',')
    @company = Company.find company_id
    Current.company = @company

    @options = { col_sep: column_separator }
  end

  def csv_data
    CSV.generate(@options) do |csv|
      data.map { |row| csv << row }
    end
  end

  def to_file
    filename = Tempfile.new ["stock_listing-", ".csv"]

    CSV.open(filename, "wb", @options) do |csv|
      data.map { |row| csv << row }
    end

    filename.path
  end

  private

    def company
      @company
    end

    def data
      @data ||= company.products.inventory_management.active.find_each.map do |product|
        row = ProductRow.new product

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

class StockListingCsv::ProductRow
  def initialize(product)
    @product = product
  end

  def product
    @product
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

  private

    def stock_raw
      @stock ||= product.stock_available
    end

    def next_order
      @next_order ||= product.purchase_order_rows.open.order(:toimaika).first
    end
end
