class StockAvailability
  ProductStockAvailability = Struct.new(:tuoteno, :nimitys, :saldo, :myohassa,
    :tulevat, :viikkodata, :loppusaldo, :yhteensa_myyty, :yhteensa_ostettu)

  def initialize(company_id:, baseline_week:, constraints:)
    @company = Company.find company_id
    @baseline_week = baseline_week
    @constraints = constraints
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
      products = @company.products.active
        .by_category(@constraints[:category])
        .by_subcategory(@constraints[:subcategory])
        .by_brand(@constraints[:brand])
        .order(:tuoteno)

      @data ||= products.map do |product|
        product_row = ProductRow.new product
        weekly_row_data = WeeklyRow.new product_row, @baseline_week
        weekly_data = weekly_row_data.data_rows

        final_stock = product_row.stock
        history_amounts = product_row.history_amount
        upcoming_amounts = product_row.upcoming_amount(@baseline_week)

        final_stock += history_amounts.purchases - history_amounts.sales
        history_amounts.change = final_stock
        final_sold = history_amounts.sales
        final_purchased = history_amounts.purchases

        weekly_data.each do |row|
          final_stock += row.stock_values.total_stock_change
          row.stock_values.total_stock_change = final_stock

          final_sold += row.stock_values.amount_sold
          final_purchased += row.stock_values.amount_purchased
        end

        final_stock += upcoming_amounts.purchases - upcoming_amounts.sales
        upcoming_amounts.change = final_stock
        final_sold += upcoming_amounts.sales
        final_purchased += upcoming_amounts.purchases

        ProductStockAvailability.new(
          product_row.product.tuoteno,
          product_row.product.nimitys,
          product_row.stock,
          history_amounts,
          upcoming_amounts,
          weekly_data,
          final_stock,
          final_sold,
          final_purchased
        )
      end
    end
end

class StockAvailability::WeeklyRow
  WeeklyData = Struct.new(:week, :stock_values)
  StockValues = Struct.new(:amount_sold, :amount_purchased,
    :total_stock_change, :order_numbers)

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

  def total_stock
    @tracked_stock
  end

  def data_rows
    all_weeks = find_week_numbers_until_baseline

    # myöhässä(past), menossa, tulossa, vapaana, tulevat(future)
    all_weeks.map do |week_number, year|
      range = find_dates_for_week_and_year(week_number, year)
      stock_values = weekly_stock_values range

      WeeklyData.new(
        "#{week_number} / #{year}",
        stock_values
      )
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
      sales_data = @product_row.product.amount_sold(range)
      amount_sold = sales_data[0]
      order_numbers = sales_data[1]
      amount_purchased = @product_row.product.amount_purchased(range)
      amount_change = amount_purchased - amount_sold
      StockValues.new(amount_sold, amount_purchased, amount_change, order_numbers)
    end

end

class StockAvailability::ProductRow
  Amounts = Struct.new(:sales, :purchases, :change)

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
    sales = product.sales_order_rows.open.where('toimaika < ?', previous_weeks_end).reserved
    purchases = product.purchase_order_rows.open.where('toimaika < ?', previous_weeks_end).reserved
    change = purchases - sales
    Amounts.new(sales, purchases, change)
  end

  def upcoming_amount(baseline_week)
    sales = product.sales_order_rows.open.where('toimaika > ?', baseline_weeks_end(baseline_week)).reserved
    purchases = product.purchase_order_rows.open.where('toimaika > ?', baseline_weeks_end(baseline_week)).reserved
    change = purchases - sales
    Amounts.new(sales, purchases, change)
  end

  private

    def stock_raw
      @stock ||= product.stock
    end

    def previous_weeks_end
      Date.today.last_week.end_of_week.end_of_day
    end

    def baseline_weeks_end(baseline_week)
      date_start = Date.today.beginning_of_week
      date_start.advance(weeks: baseline_week).end_of_week.end_of_day
    end
end
