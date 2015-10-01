require 'csv'

class StockListingCsv
  def initialize(company_id:)
    @company = Company.find company_id
    Current.company = @company
  end

  def csv_data
    CSV.generate do |csv|
      data.map { |row| csv << row }
    end
  end

  def csv_file(filename)
    CSV.open(filename, "wb") do |csv|
      data.map { |row| csv << row }
    end
  end

  private

    def company
      @company
    end

    def data
      @data ||= company.products.active.find_each.map do |product|
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
    stock_raw < 0 ? 0.0 : stock_raw
  end

  def stock_after_order
    stock = next_order ? (stock_raw + next_order.varattu) : nil
    stock && stock > 0 ? stock : nil
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
