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
        stock = product.stock_available
        next_purchase_order = product.purchase_order_rows.open.order(:toimaika).first
        order_date = next_purchase_order ? next_purchase_order.toimaika : nil
        stock_after = next_purchase_order ? (stock + next_purchase_order.varattu) : stock

        [
          product.tuoteno,
          product.eankoodi,
          product.nimitys,
          stock < 0 ? 0.0 : stock,
          order_date,
          stock_after < 0 ? 0.0 : stock_after,
        ]
      end
    end
end
