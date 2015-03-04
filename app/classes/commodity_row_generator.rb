class CommodityRowGenerator
  attr_accessor :company, :commodity, :fiscal_start, :fiscal_end, :activation_date

  def initialize(commodity_id:)
    self.commodity       = FixedAssets::Commodity.find(commodity_id)
    self.company         = commodity.company
    self.activation_date = commodity.activated_at
    self.fiscal_start    = company.current_fiscal_year.first
    self.fiscal_end      = company.current_fiscal_year.last
  end

  def fixed_by_percentage(full_amount, percentage)
    # full_amount = hydykkeen hankintahinta
    # percentage = vuosipoistoprosentti
    yearly_amount = full_amount * percentage / 100
    payments = full_amount / yearly_amount * payment_count
    payments = payments.to_i
    divide_to_payments(full_amount, payments, yearly_amount)
  end

  def degressive_by_percentage(full_amount, fiscal_percentage, depreciated_amount = 0)
    # full_amount = hydykkeen hankintahinta
    # fiscal_percentage = vuosipoistoprosentti
    # depreciated_amount = jo poistettu summa
    full_amount = full_amount.to_d

    # Sum the value of previous fiscal reductions
    full_amount = full_amount - depreciated_amount

    fiscal_percentage = fiscal_percentage.to_d / 100
    fiscal_year_depreciations = []
    first_depreciation = full_amount * fiscal_percentage / payment_count

    fiscal_year_depreciations << first_depreciation.to_i

    fiscalreduction = full_amount * fiscal_percentage
    keep_running = true

    while keep_running do
      injecthis = (full_amount - fiscal_year_depreciations.sum) * fiscal_percentage / payment_count

      if fiscal_year_depreciations.count == payment_count - 1
        injecthis = fiscalreduction - fiscal_year_depreciations.sum
        keep_running = false
      end
      injecthis = injecthis.to_i

      fiscal_year_depreciations << injecthis unless injecthis.zero?
    end

    fiscal_year_depreciations
  end

  def fixed_by_month(full_amount, total_number_of_payments, depreciated_payments = 0, depreciated_amount = 0)
    # full_amount = hydykkeen hankintahinta
    # total_number_of_payments = poistojen kokonaismäärä kuukausissa
    # depreciated_payments = jo poistettujen erien lukumäärä
    # depreciated_amount = jo poistettu summa
    remaining_payments = total_number_of_payments - depreciated_payments
    remaining_amount = full_amount - depreciated_amount

    fiscal_maximum = full_amount.to_d / total_number_of_payments * payment_count
    fiscal_maximum = fiscal_maximum.ceil

    if remaining_amount > fiscal_maximum
      remaining_amount = fiscal_maximum
    end

    # Calculate fiscal payments
    if remaining_payments >= payment_count
      divide_to_payments(remaining_amount, payment_count)
    else
      divide_to_payments(remaining_amount, remaining_payments)
    end
  end

  private

    # Calculates monthly payments within fiscal year
    def divide_to_payments(full_amount, full_count, max_fiscal_reduction = 0)
      # full_amount = hydykkeen hankintahinta
      # full_count = kokonaispoistoaika kuukausissa
      # max_fiscal_reduction = tasapoisto vuosiprosentille laskettu tilikauden maksimi
      full_amount = full_amount.to_d
      return [] if full_amount.zero? || full_count.zero?

      fiscal_maximum = full_amount / full_count * payment_count
      fiscal_maximum = fiscal_maximum.ceil

      if max_fiscal_reduction > 0 && fiscal_maximum > max_fiscal_reduction
        fiscal_maximum = max_fiscal_reduction
      end

      payment_amount = full_amount / full_count
      payment_amount = payment_amount.round(2)

      if full_amount > fiscal_maximum
        full_amount = fiscal_maximum
      end

      remainder = full_amount.divmod(payment_amount)

      result = []

      remainder[0].to_i.times do
        result << payment_amount
      end

      unless remainder[1].zero?
        if remainder[0] < payment_count
          result << remainder[1]
        else
          result[-1] += remainder[1]
        end
      end

      result
    end

    def calculation_period
      start = (activation_date < fiscal_start) ? fiscal_start : activation_date

      (start..fiscal_end)
    end

    def payment_count
      calculation_period.map(&:end_of_month).uniq.count
    end
end
