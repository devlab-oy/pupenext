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
        [
          product.tuoteno,
          product.eankoodi,
          product.nimitys,
          stock < 0 ? 0 : stock,
        ]
      end
    end
end
