class StockAvailability
  ProductStockAvailability = Struct.new(:tuoteno, :nimitys, :saldo, :myohassa,
    :tulevat, :viikkodata)

  def initialize(company_id:, baseline_week:)
    @company = Company.find company_id
    @baseline_week = baseline_week
    Current.company = @company
  end

  def to_screen
    data
  end

  def to_file
    data
    # Prawn::Document.generate("stock_availability.pdf") do
    #   data.map { |row| text row }
    # end
  end

  private

    def company
      @company
    end

    def data
      @data ||= company.products.active.find_each.map do |product|
        product_row = ProductRow.new product
        weekly_row_data = WeeklyRow.new product_row, @baseline_week

        ProductStockAvailability.new(
          product_row.product.tuoteno,
          product_row.product.nimitys,
          product_row.stock,
          product_row.history_amount,
          product_row.upcoming_amount(@baseline_week),
          weekly_row_data.data_rows
        )
      end
    end
end

class StockAvailability::WeeklyRow
  def initialize(product_row, baseline_week)
    @product_row = product_row
    @baseline_week = baseline_week
  end

  def product_row
    @product_row
  end

  def baseline_week
    @baseline_week
  end

  def data_rows
    all_weeks = find_week_numbers_until_baseline

    # myöhässä(past), menossa, tulossa, vapaana, tulevat(future)
    all_weeks.map do |week_number, year|
      range = find_dates_for_week_and_year(week_number, year)
      stock_values = weekly_stock_values range
      ["#{week_number} / #{year}", stock_values]
    end
  end

  private

    def find_dates_for_week_and_year(week_number, year)
      year ||= Date.today.year
      week_begin = Date.commercial(year, week_number, 1).beginning_of_day
      week_end = Date.commercial(year, week_number, 7).end_of_day
      week_begin..week_end
    end

    def find_week_numbers_until_baseline
      date_start = Date.today.beginning_of_week
      date_end = date_start.advance(weeks: @baseline_week)

      date_start.upto(date_end).map do |date|
        [date.cweek, date.cwyear]
      end.uniq
    end

    def weekly_stock_values(range)
      amount_sold = @product_row.product.amount_sold(range)
      amount_purchased = @product_row.product.amount_purchased(range)

      [amount_purchased.to_s, amount_sold.to_s]
    end

end

class StockAvailability::ProductRow
  def initialize(product)
    @product = product
  end

  def product
    @product
  end

  def stock
    stock_raw < 0 ? 0.0 : stock_raw
  end

  def history_amount
    sales = product.sales_order_rows.where('toimaika < ?', previous_weeks_end).reserved
    purchases = product.purchase_order_rows.where('toimaika < ?', previous_weeks_end).reserved
    [sales, purchases]
  end

  def upcoming_amount(baseline_week)
    sales = product.sales_order_rows.where('toimaika > ?', baseline_weeks_end(baseline_week)).reserved
    purchases = product.purchase_order_rows.where('toimaika > ?', baseline_weeks_end(baseline_week)).reserved
    [sales, purchases]
  end

  private

    def stock_raw
      @stock ||= product.stock_available
    end

    def previous_weeks_end
      Date.today.last_week.end_of_week.end_of_day
    end

    def baseline_weeks_end(baseline_week)
      date_start = Date.today.beginning_of_week
      date_start.advance(weeks: baseline_week).end_of_week.end_of_day
    end
end
